# 📘 Guia Completo: DB Browser for SQLite (Portable)
### Banco de Dados: Biblioteca Universitária

Este manual passo a passo foi elaborado para ensinar como criar, configurar, povoar, filtrar e testar um Banco de Dados Relacional no **SQLite Database Browser Portable (DB Browser for SQLite)**.

---

## 📑 Sumário
1. [Visão Geral e Download/Execução](#1-visão-geral-e-downloadexecução)
2. [Passo a Passo: Criar o Banco de Dados (.db)](#2-passo-a-passo-criar-o-banco-de-dados-db)
3. [Passo a Passo: Criar Tabelas e Campos (Visual vs SQL)](#3-passo-a-passo-criar-tabelas-e-campos-visual-vs-sql)
4. [Passo a Passo: Inserir Dados (Visual vs SQL)](#4-passo-a-passo-inserir-dados-visual-vs-sql)
5. [Passo a Passo: Executar o Script SQL Completo (.sql)](#5-passo-a-passo-executar-o-script-sql-completo-sql)
6. [10 Perguntas com Comandos SQL para Filtrar e Testar](#6-10-perguntas-com-comandos-sql-para-filtrar-e-testar)

---

## 1. Visão Geral e Download/Execução

O **DB Browser for SQLite Portable** é uma ferramenta gráfica simples, leve e poderosa para gerenciar bancos de dados SQLite sem necessidade de instalação complexa.

* **Interface Visual:** Permite criar tabelas, campos e registros clicando com o mouse.
* **Aba Executar SQL:** Permite rodar comandos SQL diretos (`CREATE`, `INSERT`, `SELECT`, `UPDATE`, `DELETE`).
* **Regra de Ouro no SQLite:** Qualquer alteração (criação de tabelas, inserção de dados) só fica salva permanentemente no arquivo após clicar em **"Escrever Alterações" (Write Changes)** ou pressionar `Ctrl + S`.

---

## 2. Passo a Passo: Criar o Banco de Dados (.db)

1. Abra o arquivo **`DB Browser for SQLite Portable.exe`**.
2. Na barra de ferramentas principal, clique no botão **"Novo Banco de Dados"** (ou use o menu `Arquivo` -> `Novo Banco de Dados...` / atalho `Ctrl + N`).
3. Uma janela de salvamento será exibida:
   * Navegue até a pasta desejada (ex: `Documents\atividade silvia sql`).
   * No campo **Nome do arquivo**, digite: `biblioteca_universitaria.db`.
   * Clique em **Salvar**.
4. Uma janela pop-up chamada **"Definição de Tabela"** aparecerá automaticamente. (Você pode fechá-la por enquanto ou seguir para a próxima etapa).

---

## 3. Passo a Passo: Criar Tabelas e Campos (Visual vs SQL)

Existem **duas formas** de criar as tabelas e definir os campos no DB Browser for SQLite:

### Método A: Pela Interface Gráfica (Visual)
1. Na aba **Estrutura do Banco de Dados**, clique no botão **"Criar Tabela"**.
2. No campo **Nome da Tabela**, digite: `alunos`.
3. Clique no botão **"Adicionar campo"** e preencha a tabela de colunas conforme o modelo:

| Nome do Campo | Tipo | NN (Not Null) | PK (Primary Key) | AI (Auto Increment) |
| :--- | :--- | :---: | :---: | :---: |
| `id_aluno` | INTEGER | 🗹 | 🗹 | 🗹 |
| `nome` | TEXT | 🗹 | ☐ | ☐ |
| `curso` | TEXT | 🗹 | ☐ | ☐ |
| `email` | TEXT | 🗹 | ☐ | ☐ |

4. À medida que você marca as caixas de seleção, o programa gera o comando SQL equivalente na caixa inferior.
5. Clique em **OK** para criar a tabela.

### Método B: Pela Aba "Executar SQL" (Recomendado)
1. Clique na aba **Executar SQL**.
2. Cole o código SQL abaixo no campo de texto:

```sql
-- Habilitar suporte a chaves estrangeiras
PRAGMA foreign_keys = ON;

-- Tabela de Alunos
CREATE TABLE alunos (
    id_aluno    INTEGER PRIMARY KEY AUTOINCREMENT,
    nome        TEXT NOT NULL,
    curso       TEXT NOT NULL,
    email       TEXT NOT NULL
);

-- Tabela de Livros
CREATE TABLE livros (
    id_livro        INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo          TEXT NOT NULL,
    autor           TEXT NOT NULL,
    ano_publicacao  INTEGER NOT NULL
);

-- Tabela de Exemplares
CREATE TABLE exemplares (
    id_exemplar     INTEGER PRIMARY KEY AUTOINCREMENT,
    id_livro        INTEGER NOT NULL,
    numero_exemplar INTEGER NOT NULL,
    status          TEXT NOT NULL,
    FOREIGN KEY (id_livro) REFERENCES livros(id_livro)
);

-- Tabela de Empréstimos
CREATE TABLE emprestimos (
    id_emprestimo   INTEGER PRIMARY KEY AUTOINCREMENT,
    id_aluno        INTEGER NOT NULL,
    id_exemplar     INTEGER NOT NULL,
    data_emprestimo TEXT NOT NULL,
    data_devolucao  TEXT,
    FOREIGN KEY (id_aluno)    REFERENCES alunos(id_aluno),
    FOREIGN KEY (id_exemplar) REFERENCES exemplares(id_exemplar)
);
```
3. Pressione o botão **Play (Executar todas / seleções)** ou aperte a tecla **`F5`** (ou `Ctrl + Enter`).
4. Verifique no painel abaixo a mensagem: `Consulta executada com sucesso`.

---

## 4. Passo a Passo: Inserir Dados (Visual vs SQL)

### Método A: Pela Aba "Navegar Dados" (Visual)
1. Clique na aba **Navegar Dados** (Browse Data).
2. Na caixa de seleção **Tabela**, escolha `alunos`.
3. Clique no botão **"Novo Registro"** (ou `Ctrl + Insert`).
4. Clique na célula criada e digite os valores (ex: `Ana Souza`, `Engenharia de Software`, `ana.souza@universidade.edu.br`).
5. Repita para novos registros.

### Método B: Pela Aba "Executar SQL" (Comandos SQL)
1. Clique na aba **Executar SQL**.
2. Cole os comandos `INSERT`:

```sql
-- Inserir Alunos
INSERT INTO alunos (nome, curso, email) VALUES
('Ana Souza',      'Engenharia de Software', 'ana.souza@universidade.edu.br'),
('Bruno Oliveira', 'Administracao',          'bruno.oliveira@universidade.edu.br'),
('Carla Santos',   'Ciencia da Computacao',  'carla.santos@universidade.edu.br'),
('Diego Pereira',  'Engenharia Civil',       'diego.pereira@universidade.edu.br'),
('Fernanda Lima',  'Direito',                'fernanda.lima@universidade.edu.br');

-- Inserir Livros
INSERT INTO livros (titulo, autor, ano_publicacao) VALUES
('Fundamentos de Banco de Dados',    'Carlos Almeida',    2021),
('Algoritmos e Estruturas de Dados', 'Mariana Costa',     2020),
('Introducao a Administracao',       'Roberto Martins',   2019),
('Engenharia de Software',           'Paulo Ferreira',    2022),
('Metodologia Cientifica',           'Luciana Rodrigues', 2018);

-- Inserir Exemplares
INSERT INTO exemplares (id_livro, numero_exemplar, status) VALUES
(1, 1, 'Disponivel'),
(1, 2, 'Emprestado'),
(2, 1, 'Disponivel'),
(3, 1, 'Emprestado'),
(4, 1, 'Manutencao');

-- Inserir Empréstimos
INSERT INTO emprestimos (id_aluno, id_exemplar, data_emprestimo, data_devolucao) VALUES
(1, 2, '2026-09-01', NULL),
(2, 4, '2026-09-03', '2026-09-10'),
(3, 1, '2026-09-05', '2026-09-12'),
(4, 3, '2026-09-08', '2026-09-15'),
(5, 2, '2026-09-20', NULL);
```
3. Pressione **`F5`** para executar.
4. **IMPORTANTE:** Clique no botão **"Escrever Alterações"** (Write Changes) na barra superior para salvar tudo.

---

## 5. Passo a Passo: Executar o Script SQL Completo (.sql)

Se você já possui o arquivo `biblioteca_universitaria.sql`:

1. No **DB Browser for SQLite**, clique em `Arquivo` -> `Abrir o arquivo SQL...` (ou `Ctrl + O`).
2. Selecione o arquivo `biblioteca_universitaria.sql`.
3. O código será carregado automaticamente na aba **Executar SQL**.
4. Clique no ícone de **Play azul** (ou pressione `F5`).
5. Clique em **"Escrever Alterações"** (`Ctrl + S`).

---

## 6. 10 Perguntas com Comandos SQL para Filtrar e Testar

Copie e cole cada comando na aba **Executar SQL** do DB Browser e pressione **`F5`** para visualizar o resultado!

---

### ❓ Pergunta 1
**Como listar todos os livros cadastrados na biblioteca com título, autor e ano de publicação?**

```sql
SELECT titulo, autor, ano_publicacao 
FROM livros;
```

---

### ❓ Pergunta 2
**Como filtrar apenas os livros que foram publicados a partir do ano de 2020?**

```sql
SELECT * 
FROM livros 
WHERE ano_publicacao >= 2020 
ORDER BY ano_publicacao DESC;
```

---

### ❓ Pergunta 3
**Como listar todos os alunos cadastrados em ordem alfabética crescente (de A a Z)?**

```sql
SELECT id_aluno, nome, curso, email 
FROM alunos 
ORDER BY nome ASC;
```

---

### ❓ Pergunta 4
**Como pesquisar por um aluno específico pelo nome ou curso (exemplo: alunos do curso de 'Engenharia de Software')?**

```sql
SELECT * 
FROM alunos 
WHERE curso = 'Engenharia de Software';
```

---

### ❓ Pergunta 5
**Como consultar quais exemplares físicos estão disponíveis para empréstimo no momento?**

```sql
SELECT id_exemplar, id_livro, numero_exemplar, status 
FROM exemplares 
WHERE status = 'Disponivel';
```

---

### ❓ Pergunta 6
**Como consultar quais empréstimos ainda estão EM ABERTO (livros que ainda não foram devolvidos)?**

```sql
SELECT 
    alunos.nome AS aluno,
    livros.titulo AS livro,
    emprestimos.data_emprestimo
FROM emprestimos
JOIN alunos     ON emprestimos.id_aluno    = alunos.id_aluno
JOIN exemplares ON emprestimos.id_exemplar = exemplares.id_exemplar
JOIN livros     ON exemplares.id_livro     = livros.id_livro
WHERE emprestimos.data_devolucao IS NULL;
```

---

### ❓ Pergunta 7
**Como gerar um histórico completo de empréstimos contendo Nome do Aluno, Curso, Título do Livro e Datas de Empréstimo e Devolução?**

```sql
SELECT 
    alunos.nome AS Aluno,
    alunos.curso AS Curso,
    livros.titulo AS Livro,
    emprestimos.data_emprestimo AS Emprestado_Em,
    emprestimos.data_devolucao AS Devolvido_Em
FROM emprestimos
JOIN alunos     ON emprestimos.id_aluno    = alunos.id_aluno
JOIN exemplares ON emprestimos.id_exemplar = exemplares.id_exemplar
JOIN livros     ON exemplares.id_livro     = livros.id_livro
ORDER BY emprestimos.data_emprestimo ASC;
```

---

### ❓ Pergunta 8
**Como contar a quantidade total de alunos, total de livros e total de empréstimos cadastrados?**

```sql
SELECT 
    (SELECT COUNT(*) FROM alunos)      AS total_alunos,
    (SELECT COUNT(*) FROM livros)      AS total_livros,
    (SELECT COUNT(*) FROM emprestimos)  AS total_emprestimos;
```

---

### ❓ Pergunta 9
**Como saber a quantidade total de empréstimos realizados por cada aluno (mesmo os alunos que nunca pegaram livro emprestado)?**

```sql
SELECT 
    alunos.nome,
    alunos.curso,
    COUNT(emprestimos.id_emprestimo) AS quantidade_emprestimos
FROM alunos
LEFT JOIN emprestimos ON alunos.id_aluno = emprestimos.id_aluno
GROUP BY alunos.id_aluno, alunos.nome, alunos.curso
ORDER BY quantidade_emprestimos DESC;
```

---

### ❓ Pergunta 10
**Como exibir o status de cada empréstimo indicando de forma legível se está 'Em Aberto' ou 'Devolvido'?**

```sql
SELECT 
    emprestimos.id_emprestimo,
    alunos.nome AS aluno,
    livros.titulo AS livro,
    emprestimos.data_emprestimo,
    CASE 
        WHEN emprestimos.data_devolucao IS NULL THEN '🔴 EM ABERTO'
        ELSE '🟢 DEVOLVIDO em ' || emprestimos.data_devolucao
    END AS situacao_emprestimo
FROM emprestimos
JOIN alunos     ON emprestimos.id_aluno    = alunos.id_aluno
JOIN exemplares ON emprestimos.id_exemplar = exemplares.id_exemplar
JOIN livros     ON exemplares.id_livro     = livros.id_livro;
```

---

### 💡 Dicas Importantes no DB Browser for SQLite:
* **Filtros rápidos:** Na aba **Navegar Dados**, você também pode digitar termos na caixa de texto do cabeçalho de cada coluna para aplicar filtros sem precisar escrever comandos SQL.
* **Exportar dados:** É possível exportar os resultados de qualquer consulta para arquivo CSV ou JSON clicando no botão de exportação no canto da resposta SQL.
* **Não esqueça:** Sempre clique em **Escrever Alterações** antes de fechar o programa!
