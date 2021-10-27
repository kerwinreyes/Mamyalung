class Validator {
  static String? validateQuestion({required String? ques}){
    if (ques == null) {
      return null;
    }

    if (ques.isEmpty) {
      return 'Question can\'t be empty';
    } 
  }
  
  static String? validateAns({required String? ans}){
    if (ans == null) {
      return null;
    }

    if (ans.isEmpty) {
      return 'Answer can\'t be empty';
    } 
  }
  static String? validateName({required String? name}) {
    if (name == null) {
      return null;
    }

    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }
    if(name.length < 3){
      return 'Name should be more than 2 characters';
    }

    return null;
  }


  static String? validateEmail({required String? email}) {
    

    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email!.isEmpty) {
      return 'Email can\'t be empty';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Enter a correct email';
    }

    return null;
  }

  static String? validatePassword({required String? password}) {
    String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
   
    if (password!.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with \n length at least 6';
    } else if(regExp.hasMatch(password)){
      return 'Password must contain \n 1 Upper case, 1 lowercase, \n 1 numeric number, 1 special character';
    }

        
    return null;
  }
  static String? validateLoginPassword({required String? password}) {
  
    if (password!.isEmpty) {
      return 'Password can\'t be empty';
    } 

        
    return null;
  }
}