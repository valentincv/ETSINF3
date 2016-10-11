SELECT C.nombre 
FROM Ciclista C, Etapa E
WHERE E.dorsal = C.dorsal
  AND NOT EXISTS ( SELECT * FROM Puerto P
                  WHERE P.netapa = E.netapa
                  AND C.dorsal <> P.dorsal 
  AND EXISTS ( SELECT * FROM Puerto P 
                  WHERE P.netapa = E.netapa ));