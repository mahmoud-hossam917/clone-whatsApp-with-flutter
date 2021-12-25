class USER {
  var email;
  var username;
  var password;
  var phonenumber;
  USER({this.email, this.username, this.password, this.phonenumber});
  getEmail() {
    return email;
  }

  getUsername() {
    return username;
  }

  getPassword() {
    return password;
  }

  getPhoneNumber() {
    return phonenumber;
  }
}
