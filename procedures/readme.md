# Procedure: prc_atualiza_tables.sql

## 📌 Descrição
Este script PL/SQL realiza a atualização das tabelas listadas na tabela `OINF_UPD_TABLES`. Ele segue uma abordagem segura para recriar tabelas de forma automática, garantindo a integridade dos dados e minimizando erros operacionais.

## ⚙️ Funcionalidade
A procedure executa os seguintes passos para cada tabela listada em `OINF_UPD_TABLES`:

1. **Excluir a tabela temporária (`TMP_<TABELA>`)**, caso já exista.
2. **Criar uma nova tabela temporária (`TMP_<TABELA>`)** com os dados da tabela original a partir do banco remoto (`@TRATCONV`).
3. **Excluir a tabela original (`<TABELA>`)** para liberar espaço e evitar conflitos.
4. **Renomear a tabela temporária para o nome original**, substituindo a versão antiga.
5. **Registrar sucesso ou erro** na tabela `OINF_UPD_TABLES`.

## 🛠️ Tratamento de Erros
- Se a exclusão da tabela falhar porque ela não existe, o erro é tratado e ignorado.
- Caso ocorra erro na criação da tabela temporária, o status e a mensagem de erro são registrados na tabela `OINF_UPD_TABLES`.
- Erros ao renomear a tabela são tratados e também registrados no log.

## 🔍 Estrutura da Tabela de Controle (`OINF_UPD_TABLES`)
A tabela `OINF_UPD_TABLES` armazena as informações das tabelas a serem processadas, contendo pelo menos os seguintes campos:

| Campo            | Tipo         | Descrição                                        |
|-----------------|-------------|------------------------------------------------|
| `TABELA`        | VARCHAR2(200) | Nome da tabela a ser atualizada.                |
| `OWNER`         | VARCHAR2(100) | Dono do objeto no banco remoto.                 |
| `DATA_ULTIMA_CARGA` | DATE     | Última execução bem-sucedida.                   |
| `ERRO_MSG`      | VARCHAR2(4000) | Mensagem de erro, se houver falha.              |
| `STATUS`        | VARCHAR2(50)  | Status da operação (`Sucesso` ou `Erro`).       |

## 📜 Exemplo de Uso
Para executar a procedure, basta rodar o script diretamente no banco de dados Oracle:

```sql
BEGIN
  prc_atualiza_tables;
END;
/
