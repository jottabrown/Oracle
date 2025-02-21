/*
	Procedure para realizar a limpeza de dados periodicamente.
	Author Jean Alves

*/

PROCEDURE PRC_CLEANUP_TABLES IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    vTable VARCHAR2(200);
	vTableTmpDelete VARCHAR2(255);
	vTableTempFinal VARCHAR2(255);
    vColuna VARCHAR2(255);
    vMaxDias NUMBER;
    vSql VARCHAR2(2000);
    iCount NUMBER;

    exp_tabela_inexistente EXCEPTION;
    PRAGMA EXCEPTION_INIT(exp_tabela_inexistente, -942);

BEGIN
    FOR RcleanUp IN (SELECT TABELA, COLUNA, MAX_DIAS FROM TAB_CLEANUP_TABLES WHERE NVL(FLG_LIG, 'N') = 'Y') LOOP
        vTable := RcleanUp.TABELA;
        vColuna := RcleanUp.COLUNA;
        vMaxDias := RcleanUp.MAX_DIAS;
		vTableTmpDelete := vTable || '_CLEANUP_DELETE_TMP';
		vTableTempFinal := vTable || '_CLEANUP_TMP';

		 -- capturo o número de registros deletados
        vSql := 'SELECT COUNT(*) FROM ' || vTable || ' WHERE TRUNC(' || vColuna || ') <= TRUNC(SYSDATE) - ' || vMaxDias;
		EXECUTE IMMEDIATE vSql INTO iCount;

		IF iCount > 0 THEN 
        	-- Passo 1: Aqui eu crio a tabela temporária para os registros a serem excluídos
        	BEGIN
				vSql := 'CREATE TABLE ' || vTableTmpDelete ||' AS 
        	                       SELECT * FROM ' || vTable || ' WHERE TRUNC(' || vColuna || ') <= TRUNC(SYSDATE) - ' || vMaxDias;
        	    EXECUTE IMMEDIATE vSql;
        	EXCEPTION
        	    WHEN exp_tabela_inexistente THEN
        	        DBMS_OUTPUT.PUT_LINE('A tabela ' || vTable || ' não existe.');
        	        CONTINUE; -- Pula para a próxima iteração do loop
				WHEN OTHERS THEN 
					ROLLBACK;
        			DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
    				PRC_INSERT_LOG(SQLCODE,DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || SQLERRM, 'PRC_CLEANUP_TABLES', DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' Query : ' || vSql );
    				DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - ' || SQLERRM);  
        			RAISE;
     		END;

			BEGIN 
				vSql := 'CREATE TABLE ' || vTableTempFinal ||' AS 
        	                   SELECT * FROM ' || vTable || ' MINUS SELECT * FROM ' || vTableTmpDelete;
        		-- Passo 2: Criar tabela temporária com os registros restantes
        		EXECUTE IMMEDIATE vSql;
			EXCEPTION
				WHEN OTHERS THEN 
					ROLLBACK;
        			DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
    				PRC_INSERT_LOG(SQLCODE,DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || SQLERRM, 'PRC_CLEANUP_TABLES', DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' Query : ' || vSql );
    				DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - ' || SQLERRM);  
        			RAISE;
			END;

        	-- Passo 3 : aqui eu trunco a tabela pois o DROP iria matar os index e todas as dependencias
			BEGIN 
				vSql := 'TRUNCATE TABLE ' || vTable;
        		EXECUTE IMMEDIATE vSql;
			EXCEPTION
				WHEN OTHERS THEN 
					ROLLBACK;
        			DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
    				PRC_INSERT_LOG(SQLCODE,DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || SQLERRM, 'PRC_CLEANUP_TABLES', DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' Query : ' || vSql );
    				DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - ' || SQLERRM);  
        			RAISE;
			END;

        	-- Passo 4: insert e dados na tabela 
			BEGIN
				vSql := 'INSERT INTO ' || vTable || ' SELECT * FROM ' || vTableTempFinal;
        		EXECUTE IMMEDIATE vSql;
			EXCEPTION
				WHEN OTHERS THEN 
					ROLLBACK;
        			DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
    				PRC_INSERT_LOG(SQLCODE,DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || SQLERRM, 'PRC_CLEANUP_TABLES', DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' Query : ' || vSql );
    				DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - ' || SQLERRM);  
        			RAISE;
			END;

        	-- Limpa as tabelas temporárias
			BEGIN 

        		EXECUTE IMMEDIATE 'DROP TABLE ' || vTableTmpDelete;
        		EXECUTE IMMEDIATE 'DROP TABLE ' || vTableTempFinal;

			EXCEPTION
				WHEN OTHERS THEN 
					ROLLBACK;
        			DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
    				PRC_INSERT_LOG(SQLCODE,DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || SQLERRM, 'PRC_CLEANUP_TABLES', DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' Query Erro ao dropar tabelas temporárias' );
    				DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - ' || SQLERRM);  
        			RAISE;
			END;

        	COMMIT;

        	DBMS_OUTPUT.PUT_LINE('Tabela limpa ---------> ' || vTable );
        	DBMS_OUTPUT.PUT_LINE('Total de registros Deletados ---------> ' || iCount );

        	UPDATE CLEANUP_TABLES
        	SET STATUS = 'Sucesso',
        	    LAST_UPD = SYSDATE,
        	    QTD_REG = iCount
        	WHERE TABELA = vTable;

        	COMMIT;
		ELSE 
			DBMS_OUTPUT.PUT_LINE('A tabela  ' || vTable ' Nao possui registros para deletar');
		END IF;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- Se ocorrer algum erro, reverte a transação
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro: ' || SQLERRM);
		PRC_INSERT_LOG(SQLCODE,DBMS_UTILITY.FORMAT_ERROR_STACK || ' - ' || SQLERRM, 'PRC_CLEANUP_TABLES', DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' Query : ' || vSql );
    	DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - ' || SQLERRM);  
        RAISE;
       
END PRC_CLEANUP_TABLES;
