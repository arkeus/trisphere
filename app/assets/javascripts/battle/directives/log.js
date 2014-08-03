app.directive("log", ["$timeout", function($timeout) {
    return {
        restrict: "E",
        scope: {
        	log: "=",
        },
        link: function(scope, element, attrs) {
            var scrollToBottom = function() {
                $(element).stop(true, false).animate({ scrollTop: $(element)[0].scrollHeight - $(element).outerHeight() }, { duration: 900, easing: "linear" });
            };
            
            scope.$on("log-message", function() {
            	var scrolledToBottom = $(element).scrollTop() >= $(element)[0].scrollHeight - $(element).outerHeight();
                if (scrolledToBottom) {
                    // Set a timeout, because otherwise it scrolls to the bottom before the page
                    // adds the new message and reflows.
                    $timeout(function() {
                        scrollToBottom();
                    }, 0);
                }
            });
            
            scope.$watch(function() { return scope.log.length; }, onScroll);
            
            $(window).focus(function() {
                $(element).stop(true, false).scrollTop($(element)[0].scrollHeight - $(element).outerHeight());
            });
        }
    };
}]);