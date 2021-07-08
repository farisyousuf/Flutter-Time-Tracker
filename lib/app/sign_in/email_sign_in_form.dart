import 'dart:io';

import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/utils/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

enum FormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidators {
  EmailSignInForm({Key key, @required this.auth}) : super(key: key);
  final AuthBase auth;
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;
  FormType _formType = FormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _isLoading = true;
    });
    try {
      if (_formType == FormType.signIn)
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      else
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      Navigator.of(context).pop();
    } catch (e) {
      showAlertDialog(
        context,
        title: "Sign In Failed",
        content: e.toString(),
        dialogActionText: "Ok",
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onEmailEditComplete() =>
      FocusScope.of(context).requestFocus(_passwordFocusNode);

  void _toggleForm() {
    setState(() {
      _submitted = false;
      _formType =
          _formType == FormType.signIn ? FormType.register : FormType.signIn;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren() {
    bool submitEnabled = widget.emailValidator.isValid(_email) &&
        widget.emailValidator.isValid(_password) &&
        !_isLoading;
    final _primaryText = _formType == FormType.signIn ? 'Sign in' : 'Register';
    final _secondaryText = _formType == FormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: _primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8.0),
      TextButton(
        onPressed: _isLoading ? null : _toggleForm,
        child: Text(
          _secondaryText,
        ),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    bool showErrorText =
        _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.passwordErrorText : null,
        enabled: !_isLoading,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocusNode,
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@abc.com',
        errorText: showErrorText ? widget.emailErrorText : null,
        enabled: !_isLoading,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      focusNode: _emailFocusNode,
      onChanged: (email) => _updateState(),
      onEditingComplete: _onEmailEditComplete,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: _buildChildren(),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }

  _updateState() {
    setState(() {});
  }
}
