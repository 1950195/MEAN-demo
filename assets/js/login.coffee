angular.module 'login', ['ngSanitize']
.controller 'loginCtrl', ($scope, $http, $window) ->
    $scope.user = {}

    $scope.submit = ->
        $scope.errorMsg = ''

        $http.post '/login', this.user
        .success (res) ->
            if res.success
                $window.location.href = '/'
            else
                $scope.errorMsg = res.msg
