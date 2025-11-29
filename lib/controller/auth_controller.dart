import '../models/user_model.dart';
import '/widgets/toast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../utils/app_routes.dart';

class AuthController extends ChangeNotifier {
  var txtName = TextEditingController();
  var txtEmail = TextEditingController();
  var txtpassword = TextEditingController();
  var txtPhone = TextEditingController();
  var txtGoal = TextEditingController();
  var txtEmailForgotPassword = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void createAccout(context) {
    auth
        .createUserWithEmailAndPassword(
          email: txtEmail.text,
          password: txtpassword.text,
        )
        .then((s) {
          final user = UserModel(
            id: s.user!.uid,
            name: txtName.text,
            email: txtEmail.text,
            phone: txtPhone.text,
            goal: txtGoal.text,
          );

          firestore.collection("users").doc(s.user!.uid).set(user.toMap());

          success(context, 'Usuário criado com sucesso!');
          Navigator.pop(context);
          limparCampos();
        })
        .catchError((e) {
          String mensagem;
          switch (e.code) {
            case 'email-already-in-use':
              mensagem = 'Este e-mail já está em uso.';
              break;
            case 'invalid-email':
              mensagem = 'E-mail inválido.';
              break;
            case 'weak-password':
              mensagem = 'A senha deve conter pelo menos 6 caracteres.';
              break;
            default:
              mensagem = 'Erro: ${e.message}';
          }

          error(context, mensagem);
        });
  }

  void login(context) {
    auth
        .signInWithEmailAndPassword(
          email: txtEmail.text,
          password: txtpassword.text,
        )
        .then((resultado) {
          success(context, 'Usuário autenticado com sucesso!');
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        })
        .catchError((e) {
          String message;
          switch (e.code) {
            case 'invalid-email':
              message = 'O e-mail informado é inválido.';
              break;
            case 'user-disabled':
              message = 'Este usuário foi desativado.';
              break;
            case 'user-not-found':
              message = 'Usuário não encontrado.';
              break;
            case 'wrong-password':
              message = 'Senha incorreta.';
              break;
            default:
              message = 'Erro desconhecido: ${e.message}';
          }
          error(context, message);
        });

    limparCampos();
  }

  void forgotPassword(context) {
    auth
        .sendPasswordResetEmail(email: txtEmailForgotPassword.text)
        .then((resultado) {
          success(context, 'E-mail enviado com sucesso!');
          Navigator.pop(context);
        })
        .catchError((e) {
          String mensagem;
          switch (e.code) {
            case 'invalid-email':
              mensagem = 'O e-mail informado é inválido.';
              break;
            case 'user-not-found':
              mensagem = 'Nenhum usuário encontrado com este e-mail.';
              break;
            default:
              mensagem = 'Erro: ${e.message}';
          }
          error(context, mensagem);
        });
    txtEmailForgotPassword.clear();
  }

  logout(context) {
    auth
        .signOut()
        .then((resultado) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.login);
          success(context, "Logout feito com sucesso.");
        })
        .catchError((e) {
          error(context, 'Não foi possível efetuar logout.');
        });
  }

  String? idUser() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }

  Future<UserModel?> loggedUser() async {
    final uid = idUser();
    if (uid == null) return null;

    try {
      final doc = await firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
    } catch (e) {
      print('Erro ao buscar usuário: $e');
    }
    return null;
  }

  Future<void> updatePhotoUrl(String url) async {
    final uid = idUser();
    if (uid != null) {
      await firestore.collection("users").doc(uid).update({'photoUrl': url});
      notifyListeners();
    }
  }

  void limparCampos() {
    txtName.clear();
    txtEmail.clear();
    txtpassword.clear();
    txtPhone.clear();
    txtGoal.clear();
    txtEmailForgotPassword.clear();
  }
}
