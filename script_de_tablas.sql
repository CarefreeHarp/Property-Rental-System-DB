CREATE TABLE DEUDOR (
    id NUMBER(10,0) GENERATED ALWAYS AS IDENTITY,
    tipo_doc CHAR(2) NOT NULL CHECK(tipo_doc IN ('CC','CE','PP','TI')),-- CE: Cedula de extranjeria, PP: Pasaporte
    numero_doc VARCHAR2(20) NOT NULL,
    genero CHAR(1) NOT NULL CHECK(genero IN ('M','F')),

    PRIMARY KEY (id),

    CONSTRAINT llaves_naturales_deudor UNIQUE (tipo_doc , numero_doc)
);

CREATE TABLE PRESTAMO(
    id NUMBER(10,0) GENERATED ALWAYS AS IDENTITY,
    iddeudor NUMBER(10,0) NOT NULL,
--  idbanco NUMBER(10,0) NOT NULL,                                      DESCOMENTAR CUANDO LA TABLA BANCO HAYA SIDO CREADA
    fecha DATE DEFAULT SYSDATE NOT NULL,
    valor_otorgado NUMBER(11,4) DEFAULT 0 NOT NULL CHECK(valor_otorgado >= 0),
    pagado CHAR(2) DEFAULT 'NO' NOT NULL CHECK (pagado IN ('SI','NO')),

    PRIMARY KEY (id),
    FOREIGN KEY (iddeudor) REFERENCES DEUDOR(id),
--  FOREIGN KEY (idbanco) REFERENCES BANCO(id),                         DESCOMENTAR CUANDO LA TABLA BANCO HAYA SIDO CREADA

    CONSTRAINT llaves_naturales_prestamo UNIQUE (iddeudor,/* idbanco ,*/ fecha)  --DESCOMENTAR CUANDO LA TABLA BANCO HAYA SIDO CREADA
);