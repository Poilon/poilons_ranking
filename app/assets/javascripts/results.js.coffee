app = angular.module('results_app', ['ngResource'])

app.factory 'Results', ($resource) ->
  $resource(location.pathname.concat('.json').concat(location.search), {resultId: '@id'})

app.controller 'ResultsController', ($scope, Results) ->
  $scope.results = Results.query()
  $scope.currentPage = 0
  $scope.pageSize = 100
  $scope.search =
    $:""
  $scope.filteredResults = ->
    _.filter $scope.results, (result) ->
      result.name.match($scope.search.$)
  $scope.numberOfPages = ->
    Math.ceil($scope.filteredResults().length/$scope.pageSize)

app.filter 'startFrom', ->
  (input, start) ->
    start = +start
    input.slice(start);
