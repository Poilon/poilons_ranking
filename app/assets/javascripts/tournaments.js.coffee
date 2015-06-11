app = angular.module('tournaments_app', ['ngResource'])

app.factory 'Tournaments', ($resource) ->
  $resource(location.pathname.concat('.json').concat(location.search), {tournamentId: '@id'})

app.controller 'TournamentsController', ($scope, Tournaments) ->
  $scope.tournaments = Tournaments.query()
  $scope.currentPage = 0
  $scope.pageSize = 20
  $scope.search =
    $:""
  $scope.filteredTournaments = ->
    _.filter $scope.tournaments, (tournament) ->
      tournament.name.toLowerCase().match($scope.search.$.toLowerCase())
  $scope.numberOfPages = ->
    Math.ceil($scope.filteredTournaments().length/$scope.pageSize)

app.filter 'startFrom', ->
  (input, start) ->
    start = +start
    input.slice(start);
