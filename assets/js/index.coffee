angular.module 'adminCtrls', ['ngSanitize', 'ngRoute', 'ui.bootstrap', 'ui.select']
.controller 'navCtrl', ($scope, $http, $window) ->
    $scope.logout       = ->
        $http.post '/logout'
        .success (res) ->
            if res.success
                $window.location.href = '/'

.controller 'menuCtrl', ($scope, $route, $routeParams, $http, $location) ->
    $scope.$route       = $route
    $scope.$location    = $location
    $scope.$routeParams = $routeParams

    $http.post '/index/nav'
    .success (data) ->
        $scope.navs = data

.controller 'userCtrl', ($scope, $modal, $http, $window) ->
    $scope.currentPage  = 1
    $scope.maxSize      = 10
    $scope.users        = []
    $scope.userGroups   = []
    $scope.name         = 'userCtrl'
    $scope.isShow       = false

    $scope.closeAlert   = () ->
        $scope.errorMsg = ''

    $scope.remove       = (_id, confirmMsg) ->
        $scope.errorMsg = ''

        if $window.confirm confirmMsg
            $http.post '/user/remove', {_id: _id}
            .success (res) ->
                if res.success
                    $scope.users = res.users

                else if res.timeout
                    $window.location.href = '/'

                else
                    $scope.errorMsg = res.msg

    $scope.openForm     = (type, size, user) ->
        $modal.open
            templateUrl : 'userForm.tpl'
            controller  : ($scope, $modalInstance, selected) ->
                $scope.parent       = selected.parent
                $scope.type         = selected.type
                $scope.user         = selected.user
                $scope.userGroup    = {}
                $scope.userGroups   = selected.parent.userGroups

                if user?
                    $scope.userGroup
                    .selected       = user.userGroup

                $scope.submit       = ->
                    $scope.parent
                    .errorMsg       = ''
                    $scope.user
                    .userGroup      = $scope.userGroup.selected._id

                    $http.post '/user/' + $scope.type, $scope.user
                    .success (res) ->
                        if res.success
                            $scope.parent.users = res.users

                        else if res.timeout
                            $window.location.href = '/'

                        else
                            $scope.parent.errorMsg = res.msg

                    $modalInstance.dismiss 'cancel'

                $scope.cancel       = ->
                    $modalInstance.dismiss 'cancel'

            size            : size
            resolve         :
                selected    : ->
                    type    : type
                    user    : angular.copy user
                    parent  : $scope

    $http.post '/user/get-full'
    .success (res) ->
        if res.success
            $scope.users = res.users

        else if res.timeout
            $window.location.href = '/'

        else
            console.error res.msg

    $http.post '/user-group/get-all'
    .success (res) ->
        if res.success
            $scope.userGroups = res.userGroups

        else if res.timeout
            $window.location.href = '/'

        else
            console.error res.msg

.controller 'userGroupCtrl', ($scope, $modal, $http, $window) ->
    $scope.currentPage  = 1
    $scope.maxSize      = 10
    $scope.userGroups   = []
    $scope.name         = 'userGroupCtrl'
    $scope.isShow       = false

    $scope.closeAlert   = ->
        $scope.errorMsg = ''

    $scope.remove       = (_id, confirmMsg) ->
        $scope.errorMsg = ''

        if $window.confirm confirmMsg
            $http.post '/user_group/remove', {_id: _id}
            .success (res) ->
                if res.success
                    $scope.userGroups = res.userGroups

                else if res.timeout
                    $window.location.href = '/'

                else
                    $scope.errorMsg = res.msg

    $scope.openForm     = (type, size, userGroup) ->
        $modal.open
            templateUrl : 'userGroupForm.tpl'
            controller  : ($scope, $modalInstance, selected) ->
                $scope.parent   = selected.parent
                $scope.type     = selected.type
                $scope.userGroup= selected.userGroup

                $scope.submit   = ->
                    $scope.parent.errorMsg  = ''

                    $http.post '/user-group/' + $scope.type, $scope.userGroup
                    .success (res) ->
                        if res.success
                            $scope.parent.userGroups = res.userGroups

                        else if res.timeout
                            $window.location.href = '/'

                        else
                            $scope.parent.errorMsg  = res.msg

                    $modalInstance.dismiss 'cancel'

                $scope.cancel   = ->
                    $modalInstance.dismiss 'cancel'

            size                : size
            resolve             :
                selected        : ->
                    type        : type
                    userGroup   : angular.copy userGroup
                    parent      : $scope

    $http.post '/user-group/get-full'
    .success (res) ->
        if res.success
            $scope.userGroups = res.userGroups

        else if res.timeout
            $window.location.href = '/'

        else
            console.error res.msg

.filter 'offset', () ->
    (input, start) ->
        start = parseInt start, 10
        input.slice start

.config ($routeProvider, $locationProvider) ->
    $routeProvider
    .when '/user',
        templateUrl: '/tpl/user'
        controller: 'userCtrl'
    .when '/user-group',
        templateUrl: '/tpl/user-group'
        controller: 'userGroupCtrl'
    .otherwise
        redirectTo: '/'
    $locationProvider.html5Mode true
