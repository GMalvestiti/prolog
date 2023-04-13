% Autor: Gustavo Silva Malvestiti.
% Arquivo de código fonte.

% Observação: O sistema de 24 horas foi utilizado, ao invés do sistema de 12 horas.
% Observação: O mes começa no dia 1 e termina do dia 28.
% Observação: O dia começa às 0:00 hora e acaba em 23:59:59 horas.
% Observação: Minutos e segundos não foram implementados.

% Consulta o arquivo de inserção de eventos.
:- consult('agenda.pl').

% Bases de dados dinâmicas auxiliares auxL e auxR.
:- dynamic auxL/2.
:- dynamic auxR/2.

% Limpeza das bases de dados dinâmicas auxiliares.
limpaL :- retractall(auxL(_, _)), true, !.
limpaR :- retractall(auxR(_, _)), true, !.

% Preenche a base de dados dinâmica auxL com o conteúdo da lista L.
passaL([]) :- true, !.
passaL(L) :- L = [A|B], A = [evento(A1, A2), data(A3, A4)],
    assertz(auxL(evento(A1, A2), data(A3, A4))), passaL(B), true, !.

% Requisito opcional 3: Faça uma nova versão do organizador que seja capaz de reordenar 
% os eventos para que o roteiro ocupe menos dias.
% Organiza e retorna uma lista de eventos ordenada R com base nos valores dos parâmetros.
organiza(Di, Hi, Df, Hf, R) :- 
    nonvar(Di), nonvar(Hi), nonvar(Df), nonvar(Hf),
	Di > 0, Di =< 28,
    Hi >= 0, Hi < 24,
    Df > 0, Df =< 28, Df >= Di,
    Hf >= 0, Hf < 24, Hf > Hi,
    findall([X, Y], (roteiro(X, Y),
                        Y = data(A, B), A >= Di, A =< Df, B >= Hi, B =< Hf), L),
    length(L, Jf),
    passaL(L),
    orgR1(0, Jf, R).

% Recursão que percorre e modifica a base de dados auxL, e adiciona valores ordenados em auxR.
orgR1(Ja, Jf, R) :- 
    Ja < Jf, 
    findall([X, Y], auxL(X, Y), L), L = [W|Z],
    orgR2(Z, W, Mf), Mf = [A, B],
    assertz(auxR(A, B)), retract(auxL(A, B)), orgR1(Ja + 1, Jf, R), !;
    findall([X, Y], auxR(X, Y), R), limpaL, limpaR, !.

% Recursão que encontra o evento com a menor data em uma lista de eventos.
orgR2([], M, Mf) :- M = [A, B], Mf = [A, B], true, !.
orgR2(L, M, Mf) :-
    L = [A|B],
    M = [_, data(M3, M4)],
    A = [_, data(A3, A4)],
    (A3 < M3, orgR2(B, A, Mf), !;
    A3 =:= M3, A4 < M4, orgR2(B, A, Mf), !; 
    orgR2(B, M, Mf), !).

% Requisito obrigatório 1: Exibir o roteiro em formato de lista.
exibeLista :- 
    organiza(1, 0, 28, 23, R),
    format("~n Roteiro = "),
    print(R).

% Recursão que imprime os dias e seus eventos do mes de fevereiro de 2022.
imprimeRoteiro([], _) :- true, !.
imprimeRoteiro(L, Dia) :- 
    L = [A|B], A = [evento(A1, A2), data(A3, A4)], diasSemana(A3, Nome),
    (Dia =:= A3, DiaF is Dia, true, !; 
    DiaF is A3, format("~n~n Dia ~d, ~a:", [A3, Nome]), true, !),
    format("~n ~s: Início: ~d:00, Duração: ~d horas;", [A1, A4, A2]),
    imprimeRoteiro(B, DiaF), true, !.

% Requisito obrigatório 2: Exibir o roteiro como um calendário mensal na tela.
exibeRoteiro :- 
    format("~n Roteiro de Fevereiro de 2022"), nl,
    organiza(1, 0, 28, 23, R),
    R = [A|_], A = [_, data(A3, _)],
    diasSemana(A3, Nome),
    format("~n Dia ~d, ~a:", [A3, Nome]),
    imprimeRoteiro(R, A3).

% Recursão que encontra o nome do dia da semana do mes de fevereiro de 2022.
diasSemana(1, terça).
diasSemana(2, quarta).
diasSemana(3, quinta).
diasSemana(4, sexta).
diasSemana(5, sábado).
diasSemana(6, domingo).
diasSemana(7, segunda).
diasSemana(Dia, Nome) :-
    (Dia =< 28), OutroDiaMesmoDiaSemana is Dia - 7,
    diasSemana(OutroDiaMesmoDiaSemana, Nome), true, !.

% Recursão que imprime todos os dias e seus nomes do mes de fevereiro de 2022.
imprimeDia(N, Max) :- 
    ((N =< Max), diasSemana(N, Nome),
	format(" Dia: ~d: ~a;~n", [N, Nome]), Proximo is N + 1,
	imprimeDia(Proximo, Max)), true, !; true, !.

% Requisito obrigatório 3: Mostrar o calendário de Fevereiro de 2022 sem eventos na tela.
exibeCalendario :-
	format("~n Calendário - Fevereiro de 2022 ~n"), nl, 
    imprimeDia(1,28), true, !.

% Requisito opcional 4: Implemente a adição de eventos pelo console.
adiciona(Nome, Du, Dia, Hora) :- 
    nonvar(Nome), nonvar(Du), nonvar(Dia), nonvar(Hora),
    Nome \== "", Du > 0, Dia > 0, Dia =< 28, Hora >= 0, Hora < 24,
    (not(roteiro(evento(Nome, Du), data(Dia, Hora))),
    assertz(roteiro(evento(Nome, Du), data(Dia, Hora))),
    format("~n Evento incluído! ~n"), true, !;
    format("~n Evento já existe! ~n"), true, !), true, !;
    format("~n Argumento(s) inválido(s)!"), true, !.

% Requisito opcional 5: Implemente a remoção de eventos pelo console.
remove(Nome, Du, Dia, Hora) :- 
    nonvar(Nome), nonvar(Du), nonvar(Dia), nonvar(Hora),
    Nome \== "", Du > 0, Dia > 0, Dia =< 28, Hora >= 0, Hora < 24,
    (roteiro(evento(Nome, Du), data(Dia, Hora)),
    retract(roteiro(evento(Nome, Du), data(Dia, Hora))),
    format("~n Evento excluído! ~n"), true, !;
    format("~n Evento não existe! ~n"), true, !), true, !;
    format("~n Argumento(s) inválido(s)!"), true, !.