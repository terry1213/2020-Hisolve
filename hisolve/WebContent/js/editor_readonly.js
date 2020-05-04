function editor(id){
	var code = $(id)[0];
	var editor = CodeMirror.fromTextArea(code, {
		lineNumbers : true,
		mode: "text/x-csrc",
		theme: "base16-light",
		matchBrackets: true,
		lineWrapping: true,
		styleActiveLine: true,
		readOnly: true,
		});
	editor.setSize("100%", "100%");
	return editor;
}