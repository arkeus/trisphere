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
			scope.$watch(function() { return scope.source[scope.current]; }, function() {
				var current = scope.source[scope.current];
				if (current < 0) {
					current = 0;
				}
				var max = scope.source[scope.max];
				if (current > max) {
					current = max;
				}
				$(element).find(".fill").stop(true, false).animate({
					"width": (current / max * 100) + "%"
				}, 1000);
			});
			
			element.find(".label").text(attrs.label).css("color", attrs.color);
			element.find(".fill").css("backgroundColor", attrs.color);
		},
	};
});
