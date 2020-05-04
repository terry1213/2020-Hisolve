
$(document).ready(function(){
	var code = $("#editor")[0];
	window.editor = CodeMirror.fromTextArea(code, {
		lineNumbers : true,
		mode: "text/x-csrc",
		theme: "base16-light",
		matchBrackets: true,
		lineWrapping: true,
		styleActiveLine: true,
		});
	editor.setSize("100%", "100%");
	});
