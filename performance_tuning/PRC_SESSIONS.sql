
SET SERVEROUTPUT ON 
BEGIN   
	DBMS_OUTPUT.enable (1000000);  
	
	FOR do_loop IN (SELECT session_id,
		a.object_id,
		xidsqn,   
		oracle_username,
		b.owner owner,   
		b.object_name object_name,
		b.object_type object_type
		FROM v$locked_object a, dba_objects b
		WHERE xidsqn != 0 AND b.object_id = a.object_id)  
		LOOP 
			DBMS_OUTPUT.put_line ('.'); 
			DBMS_OUTPUT.put_line ('Blocking Session   : ' || do_loop.session_id); 
			DBMS_OUTPUT.put_line ( 'Object (Owner/Name): '  || do_loop.owner  || '.'  || do_loop.object_name); 
			DBMS_OUTPUT.put_line ('Object Type        : ' || do_loop.object_type); 
			FOR next_loop IN (SELECT sid  FROM v$lock  WHERE id2 = do_loop.xidsqn AND sid != do_loop.session_id)  
			LOOP DBMS_OUTPUT.put_line ( 'Sessions being blocked   :  ' || next_loop.sid);  
			END LOOP; 
		END LOOP;  
		
END;
/
