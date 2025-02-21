DECLARE
  CURSOR cCursor IS
    SELECT *
    FROM OINF_UPD_TABLES;

  TYPE ARRAY IS TABLE OF cCursor%ROWTYPE;
  arCursor ARRAY;

  nLimit NUMBER := 30000;
  nErrorCode NUMBER;
  vErrorMessage VARCHAR2(4000);
  vSQL VARCHAR2(4000);
  vNomeTabela VARCHAR2(200);
  vOner VARCHAR2(100);
  vResult INTEGER;
  vIndexName VARCHAR2(100);
  vDDL VARCHAR2(4000);

BEGIN
  DBMS_OUTPUT.PUT_LINE('INICIO.');
  nErrorCode := 0;

  OPEN cCursor;
  LOOP
    FETCH cCursor BULK COLLECT INTO arCursor LIMIT nLimit;

    EXIT WHEN arCursor.COUNT = 0;

    FOR i IN 1..arCursor.COUNT 
    LOOP
        vNomeTabela := arCursor(i).TABELA;
        vOner := arCursor(i).OWNER;
        
        BEGIN
            -- Aqui eu Dropo a tabela 
            vSQL := 'DROP TABLE TMP_' || vNomeTabela;
            BEGIN
               EXECUTE IMMEDIATE vSQL;
                DBMS_OUTPUT.PUT_LINE('Tabela TEMP DROPADA TMP_' || vNomeTabela);
            EXCEPTION
                WHEN OTHERS THEN
                    IF SQLCODE = -942 THEN -- tabela não existe
                        DBMS_OUTPUT.PUT_LINE('A tabela TMP_' || vNomeTabela || ' não existe.');
                    ELSE
                        vErrorMessage := 'Erro ao executar o DROP TABLE: ' || SQLERRM;
                        DBMS_OUTPUT.PUT_LINE(vErrorMessage);
                       
                        UPDATE OINF_UPD_TABLES 
                            SET DATA_ULTIMA_CARGA = SYSDATE,
                                ERRO_MSG = vErrorMessage,
                                STATUS = 'Erro'
                            WHERE TABELA = vNomeTabela;
                        COMMIT;
                    END IF;
            END;
        END;

        -- Aqui eu crio a tabela temp
        BEGIN 
            vSQL := 'CREATE TABLE TMP_' || vNomeTabela || ' AS SELECT /*+ DRIVING_SITE('|| vOner ||'.' || vNomeTabela || ') */ * FROM ' || vOner ||'.' ||  vNomeTabela || '@TRATCONV';
            EXECUTE IMMEDIATE vSQL;
            DBMS_OUTPUT.PUT_LINE('Tabela TEMP CRIADA TMP_' || vNomeTabela);
        EXCEPTION
            WHEN OTHERS THEN
                vResult := SQLCODE;
                vErrorMessage := 'Erro ao executar a criação da tabela: ' || SQLERRM;
                DBMS_OUTPUT.PUT_LINE(vErrorMessage);
                UPDATE OINF_UPD_TABLES 
                    SET DATA_ULTIMA_CARGA = SYSDATE,
                        ERRO_MSG = vErrorMessage,
                        STATUS = 'Erro'
                    WHERE TABELA = vNomeTabela;
                COMMIT;
                CONTINUE; -- Continua para a próxima iteração do loop
        END;

        BEGIN 
             EXECUTE IMMEDIATE 'DROP TABLE ' || vNomeTabela;
            DBMS_OUTPUT.PUT_LINE('Tabela ' || vNomeTabela || ' removida com sucesso.');
         EXCEPTION
            WHEN OTHERS THEN
             IF SQLCODE = -942 THEN -- Tabela não existe
                 DBMS_OUTPUT.PUT_LINE('A tabela ' || vNomeTabela || ' não existe.');
            ELSE
                 DBMS_OUTPUT.PUT_LINE('Erro ao executar o DROP TABLE: ' || SQLERRM);
            END IF;
        END;

        BEGIN
        -- Aqui eu renomeio a tabela
        vSQL := 'RENAME TMP_' || vNomeTabela || ' TO ' || vNomeTabela; 
        EXECUTE IMMEDIATE vSQL;
        --DBMS_OUTPUT.PUT_LINE(vSQL);
       DBMS_OUTPUT.PUT_LINE('Tabela renomeada com sucesso: ' || vNomeTabela);

        -- Atualiza a tabela OINF_UPD_TABLES com o status de sucesso
        UPDATE OINF_UPD_TABLES 
            SET DATA_ULTIMA_CARGA = SYSDATE,
                ERRO_MSG = NULL,
                STATUS = 'Sucesso'
            WHERE TABELA = vNomeTabela;
        COMMIT;
       
       EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Erro ao renomear a tabela: ' || vNomeTabela || ' ' || SQLERRM);
            -- Atualiza a tabela OINF_UPD_TABLES com o status de erro
             vErrorMessage := 'Erro ao renomear tabela: ' || SQLERRM;
          
            UPDATE OINF_UPD_TABLES 
            SET DATA_ULTIMA_CARGA = SYSDATE,
                ERRO_MSG = vErrorMessage,
                STATUS = 'Erro'
            WHERE TABELA = vNomeTabela;
            COMMIT;
        END;



        /*
        BEGIN
        -- Busca o nome do índice pela tabela
            SELECT INDEX_NAME INTO vIndexName
                FROM ALL_INDEXES@TRATCONV
            WHERE TABLE_NAME = vNomeTabela;
  
            IF vIndexName IS NOT NULL THEN
                    SELECT dbms_metadata.get_ddl('INDEX', vIndexName) INTO vDDL
                    FROM dual;
                    DBMS_OUTPUT.PUT_LINE(vDDL);
                    EXECUTE IMMEDIATE vDDL;
            ELSE
                DBMS_OUTPUT.PUT_LINE('Índice não encontrado para a tabela ' || vNomeTabela);
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Índice não encontrado para a tabela ' || vNomeTabela);
                vIndexName := NULL;
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Erro ao buscar e gerar o DDL do índice: ' || SQLERRM);
        END; 
        */
    END LOOP;

  END LOOP;


EXCEPTION
  WHEN OTHERS THEN
    nErrorCode := SQLCODE;
    vErrorMessage := 'Erro na EXECUTION DA PL: ' || SQLERRM;
    DBMS_OUTPUT.PUT_LINE(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE || ' - ' || vErrorMessage);
    ROLLBACK;
END;


