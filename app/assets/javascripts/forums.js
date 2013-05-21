/* Forum Specific Code */ if (controller === "forums") { /* */

$(function() {
	$("#preview-button").click(function() {
		$("#preview-form #subject").val($("#post-form #subject").val());
		$("#preview-form #message").val($("#post-form #message").val());
		$("#preview-form").submit();
		return false;
	});
});

/* End Forum Specific Code */ } /* */