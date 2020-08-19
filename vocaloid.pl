cantante(megurineLuka, nightFever, 4).
cantante(megurineLuka, foreverYoung, 5).
cantante(hatsuneMiku, tellYourWorld, 4).
cantante(gumi, foreverYoung, 4).
cantante(gumi, tellYourWorld, 5).
cantante(seeU, novemberRain, 6).
cantante(seeU, nightFever, 5).

cantanteNovedoso(Cantante):-
    sabeAlMenosDosCanciones(Cantante),
    duracionTotalCanciones(Cantante, DuracionTotal),
    DuracionTotal < 15.

sabeAlMenosDosCanciones(Cantante):-
    cantante(Cantante, Cancion, _),
    cantante(Cantante, OtraCancion, _),
    Cancion \= OtraCancion.

duracionTotalCanciones(Cantante, DuracionTotal):-
    findall(Duracion, cantante(Cantante, _, Duracion),Duraciones),
    sum_list(Duraciones, DuracionTotal).
    
cantanteAcelerado(Cantante):-
    vocaloid(Cantante),
    not((cantante(Cantante, _, Duracion), Duracion > 4)).    

vocaloid(Cantante):-
    cantante(Cantante, _, _).

concierto(mikuExpo, eeuu, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalekt, eeuu, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequeno(4)).

puedeParticipar(hatsuneMiku, Concierto):-
    concierto(Concierto,_, _, _).

puedeParticipar(Cantante, Concierto):-
    vocaloid(Cantante),
    Cantante \= hatsuneMiku,
    concierto(Concierto, _, _, TipoConcierto),
    cumpleRequisitoConcierto(Cantante, TipoConcierto).

sabeCantidadCanciones(Cantante, CantidadCanciones):-
    findall(Cancion, cantante(Cantante, Cancion, _), Canciones),
    length(Canciones, CantidadCanciones).
    
cumpleRequisitoConcierto(Cantante, gigante(Cantidad, Duracion)):-
    sabeCantidadCanciones(Cantante, CantidadCancionesSabe),
    CantidadCancionesSabe >= Cantidad,
    duracionTotalCanciones(Cantante, DuracionCanciones),
    DuracionCanciones > Duracion. 

cumpleRequisitoConcierto(Cantante, mediano(Duracion)):-
    duracionTotalCanciones(Cantante, DuracionTotal),
    DuracionTotal < Duracion.

cumpleRequisitoConcierto(Cantante, pequeno(Duracion)):-
    duracionCancionSupera(Cantante, Duracion).

duracionCancionSupera(Cantante, Duracion):-
    cantante(Cantante, _, DuracionCancion),
    DuracionCancion > Duracion. 

cantanteMasFamoso(Cantante):-
    calcularFama(Cantante, NivelFama),
    forall((calcularFama(OtroCantante, OtroNivelFama), OtroCantante \= Cantante), NivelFama > OtroNivelFama).

calcularFama(Cantante, NivelFama):-
    famaTotalConciertos(Cantante, FamaTotal),
    sabeCantidadCanciones(Cantante, Cantidad),
    NivelFama is FamaTotal * Cantidad.

famaTotalConciertos(Cantante, FamaTotal):-    
    vocaloid(Cantante),
    findall(Fama, famaConcierto(Cantante, Fama), Famas),
    sum_list(Famas, FamaTotal).
    
famaConcierto(Cantante, Fama):-
    puedeParticipar(Cantante, Concierto),
    concierto(Concierto, _, Fama, _).

conocidos(megurineLuka, hatsuneMiku).
conocidos(megurineLuka, gumi).
conocidos(gumi, seeU).
conocidos(seeU, kaito).

participaUnicoCantanteConcierto(Cantante, Concierto):-
    puedeParticipar(Cantante, Concierto),
    not(participaAlgunConocido(Cantante, Concierto)).

participaAlgunConocido(Cantante, Concierto):-
    conocidos(Cantante, Conocido),
    puedeParticipar(Conocido, Concierto),
    participaAlgunConocido(Conocido, Concierto).

participaAlgunConocido(Cantante, Concierto):-
    conocidos(Cantante, Conocido),
    puedeParticipar(Conocido, Concierto).

%Si aparece un nuevo tipo de concierto tengo que agregar un hecho para ese concierto, ya que modele los tipos de concierto como individuos usando funtores, y esto me permite poder agregar los que sean necesarios a mi solucion. Tendria que agregar cumpleRequisito con el nuevo tipo de concierto y con las condiciones que este implique
%El concepto es polimorfismo, que nos permite definir el comportamiento de un tipo de concierto en particular para un mismo predicado.