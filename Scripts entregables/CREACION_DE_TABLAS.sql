CREATE TABLE DEUDOR (
    id NUMBER(10,0) GENERATED ALWAYS AS IDENTITY,
    tipo_doc CHAR(2) NOT NULL CHECK(tipo_doc IN ('CC','CE','PP','TI')),-- CE: Cedula de extranjeria, PP: Pasaporte
    numero_doc VARCHAR2(20) NOT NULL,
    genero CHAR(1) NOT NULL CHECK(genero IN ('M','F')),

    PRIMARY KEY (id),

    CONSTRAINT llaves_naturales_deudor UNIQUE (tipo_doc , numero_doc)
);

CREATE TABLE BANCO(
    id NUMBER(10,0) GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(20) NOT NULL,

    PRIMARY KEY (id),
    
    CONSTRAINT llave_natural_banco UNIQUE(nombre)
);

CREATE TABLE PRESTAMO(
    id NUMBER(10,0) GENERATED ALWAYS AS IDENTITY,
    iddeudor NUMBER(10,0) NOT NULL,
    idbanco NUMBER(10,0) NOT NULL,                                     
    fecha DATE DEFAULT SYSDATE NOT NULL,
    valor_otorgado NUMBER(14,4) DEFAULT 0 NOT NULL CHECK(valor_otorgado >= 0),
    pagado CHAR(2) DEFAULT 'NO' NOT NULL CHECK (pagado IN ('SI','NO')),

    PRIMARY KEY (id),
    FOREIGN KEY (iddeudor) REFERENCES DEUDOR(id),
    FOREIGN KEY (idbanco) REFERENCES BANCO(id),                       

    CONSTRAINT llaves_naturales_prestamo UNIQUE (iddeudor,idbanco , fecha)  
);

CREATE TABLE ABONO(
    id NUMBER(10,0) GENERATED ALWAYS AS IDENTITY,
    idprestamo NUMBER(10,0) NOT NULL,
    fecha DATE DEFAULT SYSDATE NOT NULL,
    valor_abono NUMBER(14,4) NOT NULL CHECK(valor_abono >= 0),

    PRIMARY KEY(id),
    FOREIGN KEY(idprestamo) REFERENCES PRESTAMO(id),

    CONSTRAINT llaves_naturales_abono UNIQUE(idprestamo, fecha)
);