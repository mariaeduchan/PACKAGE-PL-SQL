Este projeto implementa pacotes PL/SQL no Oracle para gerenciar entidades relacionadas a um sistema acadêmico. São criados três pacotes principais:

PKG_ALUNO: Gerencia operações relacionadas a alunos.
PKG_DISCIPLINA: Gerencia operações relacionadas às disciplinas.
PKG_PROFESSOR: Gerencia operações relacionadas aos professores.
Estrutura do Projeto
1. PKG_ALUNO
Este pacote contém procedimentos para manipular informações de alunos.

Procedures:
excluir_aluno(p_id_aluno NUMBER): Remove um aluno pelo ID e suas matrículas associadas.
listar_alunos_maiores: Lista alunos com mais de 18 anos.
listar_alunos_por_curso(p_id_curso NUMBER): Lista os alunos matriculados em um curso específico.
2. PKG_DISCIPLINA
Este pacote foca na gestão de disciplinas.

Procedures:
cadastrar_disciplina(p_nome VARCHAR2, p_descricao VARCHAR2, p_carga_horaria NUMBER): Insere uma nova disciplina na base de dados.
listar_alunos_disciplina(p_id_disciplina NUMBER): Lista os alunos matriculados em uma disciplina específica.
listar_disciplinas_com_mais_de_10_alunos: Lista disciplinas com mais de 10 alunos matriculados.
calcular_media_idade_disciplina(p_id_disciplina NUMBER): Calcula a média de idade dos alunos em uma disciplina.
3. PKG_PROFESSOR
Este pacote gerencia informações relacionadas aos professores e suas turmas.

Procedures:
listar_turmas_por_professor: Lista os professores e o total de turmas que eles lecionam (somente aqueles com mais de uma turma).
Functions:
total_turmas(p_id_professor NUMBER): Retorna o total de turmas de um professor específico.
professor_da_disciplina(p_id_disciplina NUMBER): Retorna o nome do professor responsável por uma disciplina.
Pré-requisitos
Antes de executar os scripts, certifique-se de que:

As tabelas necessárias (Aluno, Disciplina, Matricula, Professor, Turma) estão criadas.
As sequências para geração de IDs, como seq_disciplina, estão disponíveis.
A permissão para criar pacotes está habilitada no seu esquema Oracle.
Como Executar os Scripts
Configuração do Ambiente:

Abra o Oracle SQL Developer ou outra ferramenta compatível.
Conecte-se ao banco de dados com um usuário que tenha permissão para criar objetos PL/SQL.
Execução dos Pacotes:

Execute cada script na ordem abaixo:

PKG_ALUNO (Cabeçalho e Corpo)
PKG_DISCIPLINA (Cabeçalho e Corpo)
PKG_PROFESSOR (Cabeçalho e Corpo)
Copie e cole os blocos no editor SQL e execute-os utilizando o comando /.

Teste dos Pacotes:
Ative o DBMS_OUTPUT no SQL Developer:
SET SERVEROUTPUT ON;

Utilize blocos anônimos para chamar os procedimentos e verificar a funcionalidade:

BEGIN
    PKG_ALUNO.listar_alunos_maiores;
END;
/


-----Exemplos para testar o código:


1. Testando Exclusão de Aluno
BEGIN
    PKG_ALUNO.excluir_aluno(1); -- Exclui o aluno com ID 1
END;
/

2. Listando Alunos Maiores de 18 Anos
BEGIN
    PKG_ALUNO.listar_alunos_maiores;
END;
/

3. Cadastrando uma Disciplina
BEGIN
    PKG_DISCIPLINA.cadastrar_disciplina('Português', 'Língua Portuguesa', 60);
END;
/

4. Listando Professores com Mais de Uma Turma
BEGIN
    PKG_PROFESSOR.listar_turmas_por_professor;
END;
/
