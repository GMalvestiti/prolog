% Autor: Gustavo Silva Malvestiti.
% Arquivo de inserção de eventos.

% Observação: O sistema de 24 horas foi utilizado, ao invés do sistema de 12 horas.
% Observação: O mes começa no dia 1 e termina do dia 28.
% Observação: O dia começa às 0:00 hora e acaba em 23:59:59 horas.
% Observação: Minutos e segundos não foram implementados.

% Base de dados dinâmica de eventos.
:- dynamic roteiro/2.
	% Eventos com parâmetros em ordem fixa => Nome do evento, duração, dia e hora de início.
	roteiro(evento("Evento 01", 3), data(10, 2)).
	roteiro(evento("Evento 02", 4), data(13, 2)).
	roteiro(evento("Evento 03", 5), data(17, 3)).
	roteiro(evento("Evento 04", 7), data(10, 3)).
	roteiro(evento("Evento 05", 8), data(10, 4)).
	roteiro(evento("Evento 06", 5), data(10, 5)).
	roteiro(evento("Evento 07", 2), data(15, 5)).