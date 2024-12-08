-- Pacote PKG_ALUNO
CREATE OR REPLACE PACKAGE PKG_ALUNO AS
    PROCEDURE excluir_aluno(p_id_aluno NUMBER);
    PROCEDURE listar_alunos_maiores;
    PROCEDURE listar_alunos_por_curso(p_id_curso NUMBER);
END PKG_ALUNO;
/
 
CREATE OR REPLACE PACKAGE BODY PKG_ALUNO AS
    PROCEDURE excluir_aluno(p_id_aluno NUMBER) IS
    BEGIN
        DELETE FROM Matricula WHERE id_aluno = p_id_aluno;
        DELETE FROM Aluno WHERE id_aluno = p_id_aluno;
    END excluir_aluno;

    PROCEDURE listar_alunos_maiores IS
        CURSOR c_maiores IS
            SELECT nome, data_nascimento 
            FROM Aluno 
            WHERE MONTHS_BETWEEN(SYSDATE, data_nascimento) / 12 > 18;
    BEGIN
        FOR aluno IN c_maiores LOOP
            DBMS_OUTPUT.PUT_LINE('Nome: ' || aluno.nome || ', Data de Nascimento: ' || aluno.data_nascimento);
        END LOOP;
    END listar_alunos_maiores;

    PROCEDURE listar_alunos_por_curso(p_id_curso NUMBER) IS
        CURSOR c_curso IS
            SELECT nome, data_nascimento 
            FROM Aluno 
            WHERE id_curso = p_id_curso;
    BEGIN
        FOR aluno IN c_curso LOOP
            DBMS_OUTPUT.PUT_LINE('Nome: ' || aluno.nome || ', Data de Nascimento: ' || aluno.data_nascimento);
        END LOOP;
    END listar_alunos_por_curso;
END PKG_ALUNO;
/

-- Pacote PKG_DISCIPLINA
CREATE OR REPLACE PACKAGE PKG_DISCIPLINA AS
    PROCEDURE cadastrar_disciplina(p_nome VARCHAR2, p_descricao VARCHAR2, p_carga_horaria NUMBER);
    PROCEDURE listar_alunos_disciplina(p_id_disciplina NUMBER);
    PROCEDURE listar_disciplinas_com_mais_de_10_alunos;
    PROCEDURE calcular_media_idade_disciplina(p_id_disciplina NUMBER);
END PKG_DISCIPLINA;
/
 
CREATE OR REPLACE PACKAGE BODY PKG_DISCIPLINA AS
    PROCEDURE cadastrar_disciplina(p_nome VARCHAR2, p_descricao VARCHAR2, p_carga_horaria NUMBER) IS
    BEGIN
        INSERT INTO Disciplina (id_disciplina, nome, descricao, carga_horaria)
        VALUES (seq_disciplina.NEXTVAL, p_nome, p_descricao, p_carga_horaria);
    END cadastrar_disciplina;

    PROCEDURE listar_alunos_disciplina(p_id_disciplina NUMBER) IS
        CURSOR c_alunos IS
            SELECT a.nome 
            FROM Matricula m
            JOIN Aluno a ON m.id_aluno = a.id_aluno
            WHERE m.id_disciplina = p_id_disciplina;
    BEGIN
        FOR aluno IN c_alunos LOOP
            DBMS_OUTPUT.PUT_LINE('Aluno: ' || aluno.nome);
        END LOOP;
    END listar_alunos_disciplina;

    PROCEDURE listar_disciplinas_com_mais_de_10_alunos IS
        CURSOR c_disciplinas IS
            SELECT d.nome, COUNT(m.id_matricula) AS total_alunos
            FROM Disciplina d
            JOIN Matricula m ON d.id_disciplina = m.id_disciplina
            GROUP BY d.nome
            HAVING COUNT(m.id_matricula) > 10;
    BEGIN
        FOR disciplina IN c_disciplinas LOOP
            DBMS_OUTPUT.PUT_LINE('Disciplina: ' || disciplina.nome || ', Total de Alunos: ' || disciplina.total_alunos);
        END LOOP;
    END listar_disciplinas_com_mais_de_10_alunos;

    PROCEDURE calcular_media_idade_disciplina(p_id_disciplina NUMBER) IS
        v_media_idade NUMBER;
    BEGIN
        SELECT AVG(MONTHS_BETWEEN(SYSDATE, a.data_nascimento) / 12)
        INTO v_media_idade
        FROM Matricula m
        JOIN Aluno a ON m.id_aluno = a.id_aluno
        WHERE m.id_disciplina = p_id_disciplina;

        DBMS_OUTPUT.PUT_LINE('Média de idade: ' || v_media_idade);
    END calcular_media_idade_disciplina;
END PKG_DISCIPLINA;
/

-- Pacote PKG_PROFESSOR
CREATE OR REPLACE PACKAGE PKG_PROFESSOR AS
    PROCEDURE listar_turmas_por_professor;
    FUNCTION total_turmas(p_id_professor NUMBER) RETURN NUMBER;
    FUNCTION professor_da_disciplina(p_id_disciplina NUMBER) RETURN VARCHAR2;
END PKG_PROFESSOR;
/
 
CREATE OR REPLACE PACKAGE BODY PKG_PROFESSOR AS
    PROCEDURE listar_turmas_por_professor IS
        CURSOR c_turmas IS
            SELECT p.nome, COUNT(t.id_turma) AS total_turmas
            FROM Professor p
            JOIN Turma t ON p.id_professor = t.id_professor
            GROUP BY p.nome
            HAVING COUNT(t.id_turma) > 1;
    BEGIN
        FOR professor IN c_turmas LOOP
            DBMS_OUTPUT.PUT_LINE('Professor: ' || professor.nome || ', Total de Turmas: ' || professor.total_turmas);
        END LOOP;
    END listar_turmas_por_professor;

    FUNCTION total_turmas(p_id_professor NUMBER) RETURN NUMBER IS
        v_total NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_total
        FROM Turma
        WHERE id_professor = p_id_professor;
        RETURN v_total;
    END total_turmas;

    FUNCTION professor_da_disciplina(p_id_disciplina NUMBER) RETURN VARCHAR2 IS
        v_nome VARCHAR2(100);
    BEGIN
        SELECT p.nome
        INTO v_nome
        FROM Professor p
        JOIN Turma t ON p.id_professor = t.id_professor
        WHERE t.id_disciplina = p_id_disciplina;
        RETURN v_nome;
    END professor_da_disciplina;
END PKG_PROFESSOR;
/
