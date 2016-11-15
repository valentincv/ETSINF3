--List all the information of actors
SELECT *
FROM CS_ACTOR;

--Where conditional
--order by column1,column2
--all allows all row
--distinct doesn't allow repeated rows
--conditional expression AND OR NOT
--Comparison predicates =, <>, <, >=
--like
--between
--

--List the name and date of birth of all actors
SELECT nombre, fecha_nac
FROM CS_ACTOR;

--List the name and date of birth of all actors and order by country and date of birth
SELECT nombre, cod_pais, fecha_nac
FROM CS_ACTOR;
ORDER BY cod_pais, fecha_nac;

--List the name and date of birth of all the actors from the country
--with code sf15 SORTED by date of birth
SELECT nombre, fecha_nac
FROM CS_ACTOR
WHERE cod_pais = 'sf15'
ORDER BY cod_pais, fecha_nac;

--List the code of all the contries with some actor
SELECT DISTINCT COD_PAIS 
FROM BDA.CS_ACTOR;

--List the name of all the actors whose name has, as second letter a "o",
--or where the name contains two or more 'a's (% wildcard, 0 or more char)
SELECT nombre
FROM CS_actor
WHERE nombre LIKE '_o%' OR nombre LIKE '%a%a%';

-- WHERE cod_pais IS NULL 

SELECT 'Durac. Max. =', MAX(duracion), 'Durac. media. =', AVG(duracion)
FROM CS_pelicula;

--List pairs actor's name - name of the country
--3. What attributes are going to be returned?
SELECT CS_actor.nombre, CS_PAIS.NOMBRE -- PRODUCT of both tables
--1. Which tables contain the information?
FROM CS_ACTOR, CS_PAIS
--2. Which rows must be selected?
WHERE CS_actor.cod_pais = CS_Pais.cod_pais;


--EJERCICIO 3.1 
--1. List the code of the countries with some actor in ascending order.
SELECT DISTINCT COD_PAIS 
FROM BDA.CS_ACTOR
ORDER BY cod_pais;

--2. List the code and the tittle of the movies released before 1970 which are not
--based on a book. Sort the movies by the tittle.
SELECT COd_peli, titulo
FROM BDA.CS_PELICULA
WHERE cod_lib IS NULL AND ANYO < '1970'
ORDER BY titulo;

--3. List the code and name of the actors which name includes 'John'.
SELECT cod_act, nombre
FROM BDA.CS_ACTOR
WHERE nombre LIKE '%John%';

--4. List the code and tittle of the movies with a length greater 
--than 120 minutes, released in the 80's.
SELECT cod_peli, titulo
FROM BDA.CS_PELICULA
WHERE duracion > '120' AND anyo LIKE '198_%';

--5. List the code and tittle of the movies based on a book, 
--directed by a director with the last name 'Pakula'.
SELECT cod_peli, titulo
FROM cs_pelicula
WHERE cod_lib IS NOT NULL AND director LIKE '%Pakula%';

--6. How many movies are there with a length 
--greater than 120 minutes released in the 80's?
SELECT COUNT (cod_peli)
FROM CS_pelicula 
where duracion > '120' AND anyo LIKE '198_%';

--7. How many movies have been classified in the 
--genres with codes 'BB5', 'GG4', o 'JH6' ?
SELECT COUNT (DISTINCT cod_peli)
FROM cs_clasificacion
where cod_gen = 'BB5' OR cod_gen = 'GG4' OR cod_gen='JH6';

--8. In which year was published the oldest book?
SELECT min(anyo)
FROM cs_libro;

--9. What	is	the	average	length	of	the	movies	released	in	1987?
SELECT AVG(duracion)
FROM cs_pelicula
WHERE anyo='1987';

--10. What	is	the	total	length	of	the	movies	directed	by	'Steven	Spielberg'?
SELECT SUM(duracion)
FROM cs_pelicula
WHERE director='Steven Spielberg';

--3.2 Queries	using	more	than	one	relation
--11. List	the	code	and	tittle	of	the	movies	in	which	act an	actor	with	the	same	name	as the	movie	director
--(sorted	by	tittle)
SELECT DISTINCT cs_pelicula.cod_peli, titulo
FROM cs_pelicula, cs_actor, cs_actua
WHERE cs_pelicula.DIRECTOR LIKE cs_actor.NOMBRE
AND cs_actua.COD_PELI = cs_pelicula.COD_PELI
AND CS_ACTOR.COD_ACT=CS_ACTUA.COD_ACT
ORDER BY CS_PELICULA.TITULO;

--12. List	the	code	and	tittle	of	the	movies	of	the	genre	'Comedia' (sorted	by	tittle).
SELECT cs_pelicula.cod_peli, titulo
FROM cs_pelicula, cs_clasificacion, cs_genero
WHERE cs_genero.nombre = 'Comedia' 
AND cs_pelicula.cod_peli = cs_clasificacion.cod_peli 
AND cs_genero.cod_gen = cs_clasificacion.cod_gen
ORDER BY titulo;

--13. List	the	code	and	tittle	of	the	movies	based	on	a	book	published	before 1950.
SELECT cs_pelicula.cod_peli, cs_pelicula.titulo
FROM CS_pelicula, CS_libro
WHERE cs_libro.anyo < 1950
AND cs_pelicula.cod_lib IS NOT NULL
AND cs_pelicula.cod_lib=cs_libro.cod_lib
ORDER BY cs_pelicula.titulo;

--14. List	the	code	and	name	of	the	countries	in	which	were	born	the	actors	acting in	movies	of	the	genre
--'Comedia'	(sorted	by	name).
SELECT DISTINCT cs_pais.cod_pais, cs_pais.nombre
FROM cs_pais, cs_actor, cs_actua, cs_pelicula, cs_clasificacion, cs_genero
WHERE cs_pais.COD_PAIS=cs_actor.cod_pais
AND cs_actor.COD_ACT=cs_actua.COD_ACT
AND cs_pelicula.COD_PELI=cs_actua.COD_PELI
AND cs_pelicula.COD_PELI=cs_clasificacion.COD_PELI
AND cs_clasificacion.COD_GEN=cs_genero.cod_gen
AND cs_genero.nombre='Comedia'
ORDER BY cs_pais.NOMBRE;

--15. Write	again	a	query for	the	exercises	11,	12,	13, and 14	using	subqueries.
  --11. List	the	code	and	tittle	of	the	movies	in	which	act an	actor	with	the	same	name	as the	movie	director
  --(sorted	by	tittle)
  SELECT DISTINCT P.cod_peli, titulo
  FROM cs_pelicula P
  WHERE COD_PELI IN (SELECT cod_peli
                    FROM cs_actua 
                    WHERE cod_act IN (SELECT cod_act
                                      FROM cs_actor A
                                      WHERE A.nombre = P.director))
ORDER BY P.TITULO;          

  --12. List	the	code	and	tittle	of	the	movies	of	the	genre	'Comedia' (sorted	by	tittle).
  SELECT P.cod_peli, P.titulo
  FROM cs_pelicula P
  WHERE P.cod_peli  IN  (SELECT C.cod_peli     
                        FROM cs_clasificacion C   
                        WHERE cod_gen IN (SELECT G.cod_gen
                                        FROM  cs_genero G
                                        WHERE G.nombre='Comedia'))                                                                  
    ORDER BY titulo; 
    
  --13. List	the	code	and	tittle	of	the	movies	based	on	a	book	published	before 1950.
  SELECT P.cod_peli, P.titulo
  FROM CS_pelicula P
  WHERE cod_peli IN (SELECT U.cod_peli 
                      FROM CS_pelicula U
                      WHERE U.cod_lib IN (SELECT L.cod_lib
                                          FROM CS_libro L
                                          WHERE L.anyo < 1950))
  ORDER BY P.titulo;
  --14. List	the	code	and	name	of	the	countries	in	which	were	born	the	actors	acting in	movies	of	the	genre
  --'Comedia'	(sorted	by	name).
  SELECT PA.cod_pais, PA.nombre
  FROM cs_pais PA
   WHERE    PA.cod_pais IN (SELECT AC.cod_pais
                             FROM cs_actor AC
                             WHERE AC.cod_act IN (SELECT A.cod_act
                                                  FROM cs_actua A
                                                  WHERE A.cod_peli IN     (SELECT P.cod_peli
                                                                          FROM cs_pelicula P
                                                                          WHERE P.cod_peli IN ( SELECT C.cod_peli
                                                                                                FROM cs_clasificacion C
                                                                                                WHERE C.cod_gen IN ( SELECT G.cod_gen
                                                                                                                      FROM cs_genero G
                                                                                                                      WHERE G.nombre='Comedia')))))
  ORDER BY PA.NOMBRE;  

--16.List the code and name of the actors born before 1950 who perform the role 'Principal' in some movie (sorted by name)
SELECT AR.cod_act,AR.nombre
FROM cs_actor AR
WHERE EXTRACT(YEAR FROM AR.fecha_nac) < 1950 AND AR.fecha_nac IN  (   SELECT A.fecha_nac
                                                                      FROM cs_actor A
                                                                      WHERE cod_act IN(                                                         
                                                                                      SELECT AC.cod_act
                                                                                      FROM cs_actua AC
                                                                                      WHERE AC.papel = 'Principal'))
 ORDER BY AR.nombre;                                                                         

--17.List the code, tittle, and author of the books used in some movie released in the 90's(sorted by tittle)
SELECT cod_lib, titulo, autor
FROM cs_libro
WHERE cod_lib IN (SELECT cod_lib
                  FROM cs_pelicula
                  WHERE cod_peli IN (SELECT cod_peli
                                      FROM cs_pelicula
                                      WHERE anyo <= 2000 AND anyo >= 1990))
ORDER BY cs_libro.titulo;                                    

--18. List	the	code,	tittle,	and	author of	the	books	not	used	in	any	movie.                                                              
SELECT cod_lib, titulo, autor
FROM cs_libro
WHERE cod_lib NOT IN (SELECT cod_lib 
                      FROM cs_pelicula WHERE cod_lib IS NOT NULL);                    

--19.List the name of the genre (or genres) of the movies in which there is no actor acting(sorted by name).                    
SELECT G.nombre
FROM cs_genero G
WHERE G.cod_gen IN (SELECT C.cod_gen 
                        FROM cs_clasificacion C
                        WHERE C.cod_peli IN (SELECT P.cod_peli
                                            FROM cs_pelicula P
                                            WHERE P.cod_peli NOT IN (SELECT AC.cod_peli
                                                                     FROM cs_actua AC)));
                                                                
-- 20. List	the	tittle	of	the	books	used	in	some	movie with	no	actors	from	the	country	called	'USA'	(sorted	by	
--tittle).           
SELECT L.titulo
FROM cs_libro L
WHERE L.cod_lib IN (SELECT P.cod_lib
                    FROM cs_pelicula P
                    WHERE P.cod_peli NOT IN (SELECT AC.cod_peli
                                        FROM cs_actua AC
                                        WHERE AC.cod_act IN(SELECT A.cod_act
                                                            FROM cs_actor A
                                                            WHERE A.cod_pais IN( SELECT PA.cod_pais
                                                                                FROM cs_pais PA
                                                                                WHERE PA.nombre='USA'))))
                                    
ORDER BY L.titulo;
--21. How	many	movies	of	the	genre	'Comedia'	are	there	with	only	one	actor	playing the	role 'Secundario'?
                                                          
SELECT COUNT (P.cod_peli)
FROM cs_pelicula P
WHERE cod_peli IN (SELECT AC.cod_peli
                  FROM cs_actua AC
                  WHERE AC.papel='Secundario')
AND P.cod_peli IN (SELECT C.cod_peli
                  FROM cs_clasificacion C
                  WHERE C.cod_gen IN (SELECT G.cod_gen
                                      FROM cs_genero G
                                      WHERE G.nombre='Comedia'));

--22. List	the	release	year	of	the	first	movie	in	which	the	actor	named	'Jude	Law'	
--performed the	'Principal' role.
SELECT MIN(P.ANYO)
FROM cs_pelicula P
WHERE P.cod_peli IN (SELECT AC.cod_peli
                  FROM cs_actua AC
                  WHERE AC.papel = 'Principal')
AND P.cod_peli IN (SELECT AT.cod_peli
                  FROM cs_actua AT
                  WHERE AT.cod_act IN (SELECT A.cod_act
                                      FROM cs_actor A
                                      WHERE A.nombre='Jude Law'));
--23. List	the	code	and	name	of	the	oldest	actor	(or	actors).
SELECT A.cod_act, A.nombre
FROM cs_actor A
WHERE fecha_nac = (SELECT MIN(AC.fecha_nac)
                    FROM cs_ACTOR AC);
                    
--24. List	the	code,	name,	and	date	of	birth	of	the	oldest	
--actor	born	in	1940
SELECT A.cod_act, A.nombre, A.fecha_nac
FROM cs_actor A
WHERE fecha_nac IN  (SELECT MIN(ACT.fecha_nac)
                     FROM cs_ACTOR ACT
                     WHERE EXTRACT(YEAR FROM ACT.fecha_nac)='1940');
                     
--25. List	the	genre	(or	genres)	of	the	longest	movie.
SELECT G.nombre
FROM cs_genero G
WHERE cod_gen IN (SELECT C.cod_gen
                  FROM cs_clasificacion C
                  WHERE cod_peli IN (SELECT P.cod_peli 
                                     FROM cs_pelicula P
                                     WHERE duracion in (SELECT MAX(duracion)
                                                        FROM cs_pelicula)))
ORDER BY nombre;

--26. List the code and	title of the book used in the movies in
--which act actors from the country called ‘España’ (sorted	by	title).
SELECT L.cod_lib, L.titulo
FROM cs_libro L
WHERE cod_lib IN (SELECT P.cod_lib
                  FROM cs_pelicula P
                  WHERE cod_peli IN (SELECT AC.cod_peli
                                     FROM cs_actua AC
                                     WHERE cod_act IN (SELECT A.cod_act
                                                       FROM cs_actor A
                                                       WHERE cod_pais IN (SELECT PA.cod_pais
                                                                          FROM cs_pais PA
                                                                          WHERE nombre = 'España'))))
                                                                          ORDER BY titulo;
--27. List	the	title of	the	movies	of	more	than	one	genre	
--released	before	1950	(sorted	by	title).
SELECT P.titulo
FROM CS_Pelicula P
WHERE anyo < 1950
AND 1 < (SELECT COUNT(C.cod_gen)
         FROM cs_clasificacion C
         WHERE c.cod_peli = p.cod_peli)
         ORDER BY P.titulo;                

--28. List	the	number	of	movies	with	less	than	4	actors
SELECT COUNT (P.cod_peli)
FROM cs_pelicula P
WHERE 4 > (SELECT COUNT(AC.cod_act)
           FROM cs_actua AC
           WHERE p.cod_peli = AC.cod_peli);
             
--29.List the directors who have directed more than	250 minutes(considering 
--the	 length of	 all	 their	movies).  
SELECT DISTINCT p.director
FROM CS_pelicula P
WHERE 250 < (SELECT SUM(duracion)
             FROM cs_pelicula PE
             WHERE p.director = pe.director);
        
--30. List	the	year (or	years)	in	which	were	born	more	than	3	actors.
SELECT DISTINCT EXTRACT(YEAR FROM AC.fecha_nac)
FROM cs_actor AC
WHERE 3 < (SELECT COUNT(cod_act)
           FROM cs_actor A
           WHERE EXTRACT(YEAR FROM AC.fecha_nac) = EXTRACT(YEAR FROM A.fecha_nac));

--31. List	the	code	and	name	of	the	youngest	actor	who	has	participated	
--in	a	movie	of	the	genre	with	code ‘DD8’
SELECT cod_act, nombre
FROM cs_actor 
WHERE fecha_nac IN (SELECT MAX(fecha_nac)
                    FROM cs_actor
                    WHERE cod_act IN (SELECT cod_act AC
                                      FROM cs_actua AC
                                      WHERE cod_peli IN (SELECT cod_peli P
                                                         FROM cs_pelicula P
                                                         WHERE cod_peli IN (SELECT cod_peli C
                                                                            FROM cs_clasificacion C
                                                                            WHERE cod_gen IN (SELECT G.cod_gen
                                                                                              FROM cs_genero G
                                                                                              WHERE g.cod_gen='DD8')))));

--33.List the code and name of the actors such that all their roles have been 'Secundario'. 
--We are only interested in actors who have acted in some movie
SELECT DISTINCT A.nombre,A.cod_act 
FROM cs_actor A,cs_actua T
WHERE NOT EXISTS ( SELECT *
                FROM cs_actua I
                WHERE A.cod_act = I.cod_act
                AND NOT I.papel = 'Secundario')
AND a.cod_act=T.cod_act;
