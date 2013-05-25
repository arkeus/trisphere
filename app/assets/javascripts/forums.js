/* Forum Specific Code */ if (controller === "forums") { /* */

$.fn.insertTSML = function(text) {
    return this.each(function() {
    	var scrollTop = this.scrollTop;
    	var start = this.selectionStart;
    	var end = this.selectionEnd;
    	var insert = text.replace("$1", this.value.substring(start, end));
    	this.value = this.value.substring(0, start) + insert + this.value.substring(end, this.value.length);
    	this.focus();
    	this.selectionStart = start;
        this.selectionEnd = start + insert.length;
        this.scrollTop = scrollTop;
    });
};

$(function() {	
	$("#preview-button").click(function() {
		$("#preview-form #subject").val($("#post-form #subject").val());
		$("#preview-form #message").val($("#post-form #message").val());
		$("#preview-form").submit();
		return false;
	});
	
	$(".quick-reply").click(function() {
		$("#post-form").toggle();
	});
	
	var toolbarActions = {
		bold: "[b]$1[/b]",
		italic: "[i]$1[/i]",
		underline: "[u]$1[/u]",
		strikethrough: "[s]$1[/s]",
		small: "[small]$1[/small]",
		large: "[large]$1[/large]",
		image: "[img]$1[/img]",
		link: "[url=\"http://example.com\"]$1[/url]",
		left: "[left]$1[/left]",
		center: "[center]$1[/center]",
		right: "[right]$1[/right]",
		hr: "[hr]$1[/hr]",
		color: "[color=red]$1[/color]",
		quote: "[quote]$1[/quote]",
	};
	
	$.each(toolbarActions, function(button, tag) {
		$(".post-actions ." + button).click(function() {
			$("#message").insertTSML(tag);
		});
	});
});

/* End Forum Specific Code */ } /* */