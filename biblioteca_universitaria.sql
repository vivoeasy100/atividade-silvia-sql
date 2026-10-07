-- ============================================================
-- BANCO DE DADOS: BIBLIOTECA UNIVERSITÁRIA
-- Atividade Prática de SQLite
-- SQLite 3 - Compatível 100%
-- ============================================================

-- Ativar suporte a chaves estrangeiras
PRAGMA foreign_keys = ON;

-- ============================================================
-- LIMPEZA: Remove tabelas se já existirem (ordem importa!)
-- ============================================================
DROP TABLE IF EXISTS emprestimos;
DROP TABLE IF EXISTS exemplares;
DROP TABLE IF EXISTS livros;
DROP TABLE IF EXISTS alunos;

-- ============================================================
-- TABELA 1: alunos
-- Armazena os dados dos alunos da universidade
-- ============================================================
CREATE TABLE alunos (
    id_aluno    INTEGER PRIMARY KEY AUTOINCREMENT,
    nome        TEXT    NOT NULL,
    curso       TEXT    NOT NULL,
    email       TEXT    NOT NULL
);

-- ============================================================
-- TABELA 2: livros
-- Armazena os dados bibliográficos dos livros
-- ============================================================
CREATE TABLE livros (
    id_livro        INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo          TEXT    NOT NULL,
    autor           TEXT    NOT NULL,
    ano_publicacao  INTEGER NOT NULL
);

-- ============================================================
-- TABELA 3: exemplares
-- Representa as cópias físicas de cada livro
-- ============================================================
CREATE TABLE exemplares (
    id_exemplar     INTEGER PRIMARY KEY AUTOINCREMENT,
    id_livro        INTEGER NOT NULL,
    numero_exemplar INTEGER NOT NULL,
    status          TEXT    NOT NULL,
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro)
);

-- ============================================================
-- TABELA 4: emprestimos
-- Registra cada empréstimo: quem pegou, qual exemplar e quando
-- data_devolucao pode ser NULL (empréstimo ainda em aberto)
-- ============================================================
CREATE TABLE emprestimos (
    id_emprestimo   INTEGER PRIMARY KEY AUTOINCREMENT,
    id_aluno        INTEGER NOT NULL,
    id_exemplar     INTEGER NOT NULL,
    data_emprestimo TEXT    NOT NULL,
    data_devolucao  TEXT,
    FOREIGN KEY (id_aluno)    REFERENCES alunos(id_aluno),
    FOREIGN KEY (id_exemplar) REFERENCES exemplares(id_exemplar)
);

-- ============================================================
-- INSERINDO OS ALUNOS (5 registros)
-- ============================================================
INSERT INTO alunos (nome, curso, email) VALUES
('Ana Souza',      'Engenharia de Software',  'ana.souza@universidade.edu.br'),
('Bruno Oliveira', 'Administracao',            'bruno.oliveira@universidade.edu.br'),
('Carla Santos',   'Ciencia da Computacao',   'carla.santos@universidade.edu.br'),
('Diego Pereira',  'Engenharia Civil',         'diego.pereira@universidade.edu.br'),
('Fernanda Lima',  'Direito',                  'fernanda.lima@universidade.edu.br');

-- ============================================================
-- INSERINDO OS LIVROS (5 registros)
-- ============================================================
INSERT INTO livros (titulo, autor, ano_publicacao) VALUES
('Fundamentos de Banco de Dados',      'Carlos Almeida',    2021),
('Algoritmos e Estruturas de Dados',   'Mariana Costa',     2020),
('Introducao a Administracao',         'Roberto Martins',   2019),
('Engenharia de Software',             'Paulo Ferreira',    2022),
('Metodologia Cientifica',             'Luciana Rodrigues', 2018);

-- ============================================================
-- INSERINDO OS EXEMPLARES (5 registros)
-- ============================================================
INSERT INTO exemplares (id_livro, numero_exemplar, status) VALUES
(1, 1, 'Disponivel'),
(1, 2, 'Emprestado'),
(2, 1, 'Disponivel'),
(3, 1, 'Emprestado'),
(4, 1, 'Manutencao');

-- ============================================================
-- INSERINDO OS EMPRÉSTIMOS (5 registros)
-- ============================================================
INSERT INTO emprestimos (id_aluno, id_exemplar, data_emprestimo, data_devolucao) VALUES
(1, 2, '2026-09-01', NULL),
(2, 4, '2026-09-03', '2026-09-10'),
(3, 1, '2026-09-05', '2026-09-12'),
(4, 3, '2026-09-08', '2026-09-15'),
(5, 2, '2026-09-20', NULL);

-- ============================================================
-- CONSULTAS DE VERIFICAÇÃO
-- ============================================================
SELECT * FROM alunos;
SELECT * FROM livros;
SELECT * FROM exemplares;
SELECT * FROM emprestimos;

-- Livros publicados depois de 2020
SELECT * FROM livros WHERE ano_publicacao > 2020;

-- Alunos em ordem alfabética
SELECT * FROM alunos ORDER BY nome ASC;

-- Livros do mais recente ao mais antigo
SELECT * FROM livros ORDER BY ano_publicacao DESC;

-- Histórico completo de empréstimos
SELECT
    alunos.nome,
    alunos.curso,
    livros.titulo,
    emprestimos.data_emprestimo,
    emprestimos.data_devolucao
FROM emprestimos
JOIN alunos     ON emprestimos.id_aluno    = alunos.id_aluno
JOIN exemplares ON emprestimos.id_exemplar = exemplares.id_exemplar
JOIN livros     ON exemplares.id_livro     = livros.id_livro;

-- Empréstimos ainda em aberto
SELECT
    alunos.nome,
    livros.titulo,
    emprestimos.data_emprestimo
FROM emprestimos
JOIN alunos     ON emprestimos.id_aluno    = alunos.id_aluno
JOIN exemplares ON emprestimos.id_exemplar = exemplares.id_exemplar
JOIN livros     ON exemplares.id_livro     = livros.id_livro
WHERE emprestimos.data_devolucao IS NULL;

-- Total de alunos, livros e empréstimos
SELECT COUNT(*) AS total_alunos FROM alunos;
SELECT COUNT(*) AS total_livros FROM livros;
SELECT COUNT(*) AS total_emprestimos FROM emprestimos;

-- Quantos empréstimos cada aluno realizou
SELECT
    alunos.nome,
    COUNT(emprestimos.id_emprestimo) AS quantidade_emprestimos
FROM alunos
LEFT JOIN emprestimos ON alunos.id_aluno = emprestimos.id_aluno
GROUP BY alunos.id_aluno, alunos.nome;

-- Situação de cada empréstimo com CASE
SELECT
    alunos.nome,
    alunos.curso,
    livros.titulo,
    exemplares.numero_exemplar,
    emprestimos.data_emprestimo,
    CASE
        WHEN emprestimos.data_devolucao IS NULL THEN 'Em aberto'
        ELSE 'Devolvido'
    END AS situacao
FROM emprestimos
JOIN alunos     ON emprestimos.id_aluno    = alunos.id_aluno
JOIN exemplares ON emprestimos.id_exemplar = exemplares.id_exemplar
JOIN livros     ON exemplares.id_livro     = livros.id_livro;

-- Exemplares disponíveis
SELECT * FROM exemplares WHERE status = 'Disponivel';

-- Histórico completo ordenado por data
SELECT
    alunos.nome          AS aluno,
    livros.titulo        AS livro,
    exemplares.numero_exemplar AS exemplar,
    emprestimos.data_emprestimo,
    emprestimos.data_devolucao
FROM emprestimos
JOIN alunos     ON emprestimos.id_aluno    = alunos.id_aluno
JOIN exemplares ON emprestimos.id_exemplar = exemplares.id_exemplar
JOIN livros     ON exemplares.id_livro     = livros.id_livro
ORDER BY emprestimos.data_emprestimo;

-- ============================================================
-- FIM DO SCRIPT
-- ============================================================
