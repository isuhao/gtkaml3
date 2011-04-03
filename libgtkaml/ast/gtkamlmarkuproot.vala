using GLib;
using Vala;

public class Gtkaml.Ast.MarkupRoot : MarkupTag {

	public MarkupRoot (MarkupClass markup_class, string tag_name, MarkupNamespace tag_namespace, SourceReference? source_reference = null) {
		base (markup_class, tag_name, tag_namespace, source_reference);
	}
	
	public override string me { get { return "this"; } }

	public override void generate_public_ast (MarkupParser parser) throws ParseError {
		markup_class.add_base_type (data_type.copy ());
		markup_class.constructor = new Constructor (markup_class.source_reference);
		markup_class.constructor.body = new Block (markup_class.source_reference);	
		parse_class_members (parser, this.text);
	}

	public override void generate (MarkupResolver resolver) throws ParseError {
		generate_creation_method (resolver);
	}

	/**
	 * returns the list of possible creation methods, in root's case, only the default creation method
	 * TODO: is this still necessary? maybe we should allow more candidates here too
	 */
	internal override Vala.List<CreationMethod> get_creation_method_candidates () {
		var candidates = base.get_creation_method_candidates ();
		foreach (var candidate in candidates) {
			if (candidate.name == ".new") {
				candidates = new Vala.ArrayList<CreationMethod> ();
				candidates.add (candidate);
				break;//before foreach complains
			}
		}
		assert (candidates.size == 1);
		return candidates;
	}

	protected override void resolve_creation_method_failed (SourceReference source_reference, string message) {
		Report.warning (source_reference, message);
	}


	private void parse_class_members (MarkupParser parser, string source) throws ParseError {
		var temp_class = parser.code_parser.parse_members (markup_class, source);
		foreach (var x in temp_class.get_constants ()) { markup_class.add_constant (x); };
		foreach (var x in temp_class.get_fields ()) { markup_class.add_field (x); };
		foreach (var x in temp_class.get_methods ()) {
			if (!(x is CreationMethod && ((CreationMethod)x).name == ".new"))  {
				markup_class.add_method (x);
			} else {
				Report.warning (null, "Ignoring %s () creation member".printf (markup_class.name));
			}
		}
		foreach (var x in temp_class.get_properties ()) { markup_class.add_property (x); };
		foreach (var x in temp_class.get_signals ()) { markup_class.add_signal (x); };
		foreach (var x in temp_class.get_classes ()) { markup_class.add_class (x); };
		foreach (var x in temp_class.get_structs ()) { markup_class.add_struct (x); };
		foreach (var x in temp_class.get_enums ()) { markup_class.add_enum (x); };
		foreach (var x in temp_class.get_delegates ()) { markup_class.add_delegate (x); };
		
	}

	/**
	 * generate creation method with base () call
	 * FIXME currently ran at resolve time
	 */
	private void generate_creation_method (MarkupResolver resolver) {
		CreationMethod creation_method = new CreationMethod(markup_class.name, null, markup_class.source_reference);
		creation_method.access = SymbolAccessibility.PUBLIC;
		
		var block = new Block (markup_class.source_reference);

		creation_method.body = block;
		
		markup_class.add_method (creation_method);
	}

}
