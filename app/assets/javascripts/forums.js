/* Forum Specific Code */ if (controller === "forums") { /* */

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
});

/* End Forum Specific Code */ } /* */