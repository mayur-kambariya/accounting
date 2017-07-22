var mainApp = angular.module("bankTransferApp", []);

mainApp.controller("transferCtrl",['$scope','$http', function($scope, $http) {

  $scope.availableBalance = 0;
  $scope.users = [];
  $scope.currentUser = "";
  $scope.statements = [];
  $scope.transferUser = 0;
  $scope.transferUserAccounts = [];
  $scope.successAlert = false;
  $scope.successTextAlert = " ";

  $scope.filterTransferAccount = function(id) {
    $scope.transferUserAccounts = [];
    for (var i = 0; i < $scope.users.length; i++)
      if ($scope.users[i].id !== id) {
        $scope.transferUserAccounts.push($scope.users[i]);
      }
  }

  $scope.switchUser = function(id) {
    $http.get("/get_dashboard?from_account_id=" + id).then(function(response) {
      $scope.prepareDashboardData(response);
    })
    $scope.filterTransferAccount(id);
    $scope.successAlert = false;
  }
  $scope.depositMoney = function(id, amount) {
    var deposit = {
      from_account_id: id,
      amount: amount
    };
    $('#depositModal').modal('toggle');
    $scope.sendRequest('/deposit', 'POST', deposit)
    .then(function(response) {
      $scope.prepareDashboardData(response);
      $scope.setFlashMessage(response.data, "$" + amount + " has been deposited  successfully to your account.");
      $scope.depositAmount = '';
    });
  }

  $scope.withdrawMoney = function(id, amount) {
    var withdraw = {
      from_account_id: id,
      amount: amount
    };
    $('#withdrawModal').modal('toggle');
    $scope.sendRequest('/withdraw', 'POST', withdraw)
    .then(function(response) {
      $scope.prepareDashboardData(response);
      $scope.setFlashMessage(response.data, "$" + amount + " has been withdrawn successfully from your account.");
      $scope.withdrawAmount = '';
    });
  }

  $scope.transferMoney = function(currentUser_id, amount, transferaccount_id) {
    var details = {
      from_account_id: currentUser_id,
      amount: amount,
      to_account_id: transferaccount_id
    };
    $('#transferModal').modal('toggle');
    $scope.sendRequest('/transfer', 'POST', details)
    .then(function(response) {
      $scope.prepareDashboardData(response);
      $scope.setFlashMessage(response.data, "$" + amount + " has beed transferred successfully from your account.");
      $scope.transferAmount = '';
    });
  }

  $scope.closeAlert = function() {
    $scope.successAlert = false;
    $scope.errorAlert = false;
  }
  $scope.setFlashMessage = function(data, meassage) {
    if (data.success) {
      $scope.successAlert = true;
      $scope.errorAlert = false;
      $scope.successTextAlert = meassage
    } else {
      $scope.errorAlert = true;
      $scope.successAlert = false;
      $scope.errorTextAlert = data.message;
    }
  }

  $scope.prepareDashboardData = function(response) {
    $scope.statements = response.data.account_details;
    $scope.availableBalance = response.data.current_balance;
    $scope.users = response.data.users;
    $scope.currentUser = response.data.current_account;
  }

  $scope.sendRequest = function(url, methodType, data){
    return $http({
      method: methodType,
      url: url,
      dataType: 'json',
      data: data,
      responseType: 'json',
      headers: {
        'content-type': 'application/json'
      }
    })
  }

  $scope.sendRequest("/get_dashboard", 'GET', {}).then(function(response) {
    $scope.prepareDashboardData(response);
    $scope.filterTransferAccount($scope.currentUser.id);
  });
}]);
