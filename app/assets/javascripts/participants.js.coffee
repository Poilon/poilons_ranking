app = angular.module('application', ['ngResource'])

app.factory 'Participants', ($resource) ->
  $resource(location.pathname.concat('.json').concat(location.search), {participantId: '@id'})

app.controller 'ParticipantsController', ($scope, Participants) ->
  $scope.participants = Participants.query()
  $scope.currentPage = 0
  $scope.pageSize = 100
  $scope.search =
    $:""
  $scope.filteredParticipants = ->
    _.filter $scope.participants, (participant) ->
      (participant.name + participant.country \
      + participant.character1_slug + participant.character2_slug \
      + participant.character3_slug + participant.character4_slug \
      + participant.character5_slug).toLowerCase().match($scope.search.$.toLowerCase())

  $scope.numberOfPages = ->
    Math.ceil($scope.filteredParticipants().length/$scope.pageSize)

app.filter 'startFrom', ->
  (input, start) ->
    start = +start
    input.slice(start);
