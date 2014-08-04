app.directive("bar", function() {
	return {
		restrict: "E",
		scope: {
			source: "=",
			current: "@",
			max: "@",
		},
		templateUrl: "templates/bar.html",
		link: function(scope, element, attrs) {
			var resize = function(instant) {
				var current = scope.source[scope.current];
				if (current < 0) {
					current = 0;
				}
				var max = scope.source[scope.max];
				if (current > max) {
					current = max;
				}
				var computedWidth = (current / max * 100) + "%";
				var fill = $(element).find(".fill").stop(true, false);
				if (instant === true) {
					fill.css("width", computedWidth);
				} else {
					fill.animate({ "width": computedWidth }, 1000);
				}
			};
			
			scope.$watch(function() { return scope.source[scope.current]; }, resize);
			
			var width = attrs.width;
			element.find(".bar").css("width", width).find(".unfill").css("width", width - 22);
			element.find(".label").text(attrs.label).css("color", attrs.color);
			element.find(".fill").css("backgroundColor", attrs.color);
			if (attrs.instant) {
				resize(true);
			}
		},
	};
});
