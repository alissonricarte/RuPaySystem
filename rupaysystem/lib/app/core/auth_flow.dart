/// Estado global do fluxo de recuperação de senha.
/// É marcado como true no main.dart quando o Supabase dispara o evento
/// passwordRecovery (usuário clicou no link do e-mail).
bool emRecuperacaoSenha = false;