PGDMP                         {            vendas    15.2    15.1 8    ?           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            @           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            A           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            B           1262    39655    vendas    DATABASE     }   CREATE DATABASE vendas WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE vendas;
                postgres    false            �            1255    39755    create_view()    FUNCTION     2  CREATE FUNCTION public.create_view() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
begin
IF NOT EXISTS (SELECT data_entrada FROM item_estoque
WHERE EXTRACT (DAY FROM data_entrada) = EXTRACT(day FROM NOW()))
THEN
EXECUTE 'CREATE MATERIALIZED VIEW vwm_produto_estoque_' || to_char(current_date - 1, 'dd_mm_yyyy') || 
' AS select data_entrada, p.nome, count(id_item) as qtd from item_estoque
inner join produto p
on p.id_produto = item_estoque.id_produto
where data_entrada = current_date - 1
group by data_entrada, p.nome;';
END IF;
RETURN NULL;
end;
$$;
 $   DROP FUNCTION public.create_view();
       public          postgres    false            �            1255    39724    creatematerializedview()    FUNCTION       CREATE FUNCTION public.creatematerializedview() RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    viewName VARCHAR(255);
    currentDate DATE;
BEGIN
    -- Obtém a data atual
    currentDate := CURRENT_DATE;

    -- Verifica se a view para a data atual já existe
    viewName := CONCAT('wvm_produto_estoque_', TO_CHAR(currentDate, 'DD_MM_YYYY'));
    IF EXISTS (SELECT 1 FROM information_schema.views WHERE table_name = viewName) THEN
        -- Se a view já existe, encerra a execução
        RETURN;
    END IF;

    -- Cria a view materializada
    EXECUTE 'CREATE MATERIALIZED VIEW ' || viewName || ' AS
              SELECT p.nome AS produto, SUM(e.quantidade) AS estoque
              FROM item_estoque e
              JOIN produto p ON e.id_produto = p.id_produto
              WHERE DATE(e.data_entrada) = CURRENT_DATE
              GROUP BY p.nome';

    -- Insere a nova view na tabela de gerenciamento
    INSERT INTO views_criadas (nome_view, data_criacao)
    VALUES (viewName, currentDate);
END;
$$;
 /   DROP FUNCTION public.creatematerializedview();
       public          postgres    false            �            1259    39663    cliente    TABLE     `   CREATE TABLE public.cliente (
    id_cliente integer NOT NULL,
    cpf character varying(11)
);
    DROP TABLE public.cliente;
       public         heap    postgres    false            �            1259    39673 
   fornecedor    TABLE     g   CREATE TABLE public.fornecedor (
    id_fornecedor integer NOT NULL,
    cnpj character varying(14)
);
    DROP TABLE public.fornecedor;
       public         heap    postgres    false            �            1259    39708    item_estoque    TABLE     �   CREATE TABLE public.item_estoque (
    id_item integer NOT NULL,
    id_produto integer NOT NULL,
    id_venda integer NOT NULL,
    data_entrada date
);
     DROP TABLE public.item_estoque;
       public         heap    postgres    false            �            1259    39707    item_estoque_id_item_seq    SEQUENCE     �   CREATE SEQUENCE public.item_estoque_id_item_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.item_estoque_id_item_seq;
       public          postgres    false    223            C           0    0    item_estoque_id_item_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.item_estoque_id_item_seq OWNED BY public.item_estoque.id_item;
          public          postgres    false    222            �            1259    39657    pessoa    TABLE     �   CREATE TABLE public.pessoa (
    id_pessoa integer NOT NULL,
    nome character varying(100) NOT NULL,
    endereco character varying(100) NOT NULL
);
    DROP TABLE public.pessoa;
       public         heap    postgres    false            �            1259    39656    pessoa_id_pessoa_seq    SEQUENCE     �   CREATE SEQUENCE public.pessoa_id_pessoa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.pessoa_id_pessoa_seq;
       public          postgres    false    215            D           0    0    pessoa_id_pessoa_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.pessoa_id_pessoa_seq OWNED BY public.pessoa.id_pessoa;
          public          postgres    false    214            �            1259    39684    produto    TABLE     �   CREATE TABLE public.produto (
    id_produto integer NOT NULL,
    id_fornecedor integer NOT NULL,
    nome character varying(100) NOT NULL,
    preco double precision NOT NULL
);
    DROP TABLE public.produto;
       public         heap    postgres    false            �            1259    39683    produto_id_produto_seq    SEQUENCE     �   CREATE SEQUENCE public.produto_id_produto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.produto_id_produto_seq;
       public          postgres    false    219            E           0    0    produto_id_produto_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.produto_id_produto_seq OWNED BY public.produto.id_produto;
          public          postgres    false    218            �            1259    39696    venda    TABLE     {   CREATE TABLE public.venda (
    id_venda integer NOT NULL,
    id_cliente integer NOT NULL,
    data_hora date NOT NULL
);
    DROP TABLE public.venda;
       public         heap    postgres    false            �            1259    39695    venda_id_venda_seq    SEQUENCE     �   CREATE SEQUENCE public.venda_id_venda_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.venda_id_venda_seq;
       public          postgres    false    221            F           0    0    venda_id_venda_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.venda_id_venda_seq OWNED BY public.venda.id_venda;
          public          postgres    false    220            �            1259    39726    views_criadas    TABLE     |   CREATE TABLE public.views_criadas (
    id integer NOT NULL,
    nome_view character varying(255),
    data_criacao date
);
 !   DROP TABLE public.views_criadas;
       public         heap    postgres    false            �            1259    39725    views_criadas_id_seq    SEQUENCE     �   CREATE SEQUENCE public.views_criadas_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.views_criadas_id_seq;
       public          postgres    false    225            G           0    0    views_criadas_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.views_criadas_id_seq OWNED BY public.views_criadas.id;
          public          postgres    false    224            �            1259    39761    vwm_produto_estoque_06_06_2023    MATERIALIZED VIEW     u  CREATE MATERIALIZED VIEW public.vwm_produto_estoque_06_06_2023 AS
 SELECT item_estoque.data_entrada,
    p.nome,
    count(item_estoque.id_item) AS qtd
   FROM (public.item_estoque
     JOIN public.produto p ON ((p.id_produto = item_estoque.id_produto)))
  WHERE (item_estoque.data_entrada = (CURRENT_DATE - 1))
  GROUP BY item_estoque.data_entrada, p.nome
  WITH NO DATA;
 >   DROP MATERIALIZED VIEW public.vwm_produto_estoque_06_06_2023;
       public         heap    postgres    false    223    223    223    219    219            �           2604    39711    item_estoque id_item    DEFAULT     |   ALTER TABLE ONLY public.item_estoque ALTER COLUMN id_item SET DEFAULT nextval('public.item_estoque_id_item_seq'::regclass);
 C   ALTER TABLE public.item_estoque ALTER COLUMN id_item DROP DEFAULT;
       public          postgres    false    223    222    223            �           2604    39660    pessoa id_pessoa    DEFAULT     t   ALTER TABLE ONLY public.pessoa ALTER COLUMN id_pessoa SET DEFAULT nextval('public.pessoa_id_pessoa_seq'::regclass);
 ?   ALTER TABLE public.pessoa ALTER COLUMN id_pessoa DROP DEFAULT;
       public          postgres    false    215    214    215            �           2604    39687    produto id_produto    DEFAULT     x   ALTER TABLE ONLY public.produto ALTER COLUMN id_produto SET DEFAULT nextval('public.produto_id_produto_seq'::regclass);
 A   ALTER TABLE public.produto ALTER COLUMN id_produto DROP DEFAULT;
       public          postgres    false    218    219    219            �           2604    39699    venda id_venda    DEFAULT     p   ALTER TABLE ONLY public.venda ALTER COLUMN id_venda SET DEFAULT nextval('public.venda_id_venda_seq'::regclass);
 =   ALTER TABLE public.venda ALTER COLUMN id_venda DROP DEFAULT;
       public          postgres    false    221    220    221            �           2604    39729    views_criadas id    DEFAULT     t   ALTER TABLE ONLY public.views_criadas ALTER COLUMN id SET DEFAULT nextval('public.views_criadas_id_seq'::regclass);
 ?   ALTER TABLE public.views_criadas ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224    225            2          0    39663    cliente 
   TABLE DATA           2   COPY public.cliente (id_cliente, cpf) FROM stdin;
    public          postgres    false    216   �E       3          0    39673 
   fornecedor 
   TABLE DATA           9   COPY public.fornecedor (id_fornecedor, cnpj) FROM stdin;
    public          postgres    false    217   JF       9          0    39708    item_estoque 
   TABLE DATA           S   COPY public.item_estoque (id_item, id_produto, id_venda, data_entrada) FROM stdin;
    public          postgres    false    223   �F       1          0    39657    pessoa 
   TABLE DATA           ;   COPY public.pessoa (id_pessoa, nome, endereco) FROM stdin;
    public          postgres    false    215   QG       5          0    39684    produto 
   TABLE DATA           I   COPY public.produto (id_produto, id_fornecedor, nome, preco) FROM stdin;
    public          postgres    false    219   �H       7          0    39696    venda 
   TABLE DATA           @   COPY public.venda (id_venda, id_cliente, data_hora) FROM stdin;
    public          postgres    false    221   fI       ;          0    39726    views_criadas 
   TABLE DATA           D   COPY public.views_criadas (id, nome_view, data_criacao) FROM stdin;
    public          postgres    false    225   �I       H           0    0    item_estoque_id_item_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.item_estoque_id_item_seq', 56, true);
          public          postgres    false    222            I           0    0    pessoa_id_pessoa_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.pessoa_id_pessoa_seq', 10, true);
          public          postgres    false    214            J           0    0    produto_id_produto_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.produto_id_produto_seq', 10, true);
          public          postgres    false    218            K           0    0    venda_id_venda_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.venda_id_venda_seq', 10, true);
          public          postgres    false    220            L           0    0    views_criadas_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.views_criadas_id_seq', 1, false);
          public          postgres    false    224            �           2606    39667    cliente cliente_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public            postgres    false    216            �           2606    39677    fornecedor fornecedor_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.fornecedor
    ADD CONSTRAINT fornecedor_pkey PRIMARY KEY (id_fornecedor);
 D   ALTER TABLE ONLY public.fornecedor DROP CONSTRAINT fornecedor_pkey;
       public            postgres    false    217            �           2606    39713    item_estoque item_estoque_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.item_estoque
    ADD CONSTRAINT item_estoque_pkey PRIMARY KEY (id_item);
 H   ALTER TABLE ONLY public.item_estoque DROP CONSTRAINT item_estoque_pkey;
       public            postgres    false    223            �           2606    39662    pessoa pessoa_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (id_pessoa);
 <   ALTER TABLE ONLY public.pessoa DROP CONSTRAINT pessoa_pkey;
       public            postgres    false    215            �           2606    39689    produto produto_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id_produto);
 >   ALTER TABLE ONLY public.produto DROP CONSTRAINT produto_pkey;
       public            postgres    false    219            �           2606    39701    venda venda_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (id_venda);
 :   ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_pkey;
       public            postgres    false    221            �           2606    39731     views_criadas views_criadas_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.views_criadas
    ADD CONSTRAINT views_criadas_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.views_criadas DROP CONSTRAINT views_criadas_pkey;
       public            postgres    false    225            �           2620    39756 #   item_estoque createviewmaterialized    TRIGGER     �   CREATE TRIGGER createviewmaterialized BEFORE INSERT ON public.item_estoque FOR EACH STATEMENT EXECUTE FUNCTION public.create_view();
 <   DROP TRIGGER createviewmaterialized ON public.item_estoque;
       public          postgres    false    223    228            �           2606    39668    cliente cliente_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.pessoa(id_pessoa);
 I   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_id_cliente_fkey;
       public          postgres    false    216    3213    215            �           2606    39678 (   fornecedor fornecedor_id_fornecedor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fornecedor
    ADD CONSTRAINT fornecedor_id_fornecedor_fkey FOREIGN KEY (id_fornecedor) REFERENCES public.pessoa(id_pessoa);
 R   ALTER TABLE ONLY public.fornecedor DROP CONSTRAINT fornecedor_id_fornecedor_fkey;
       public          postgres    false    217    215    3213            �           2606    39714 )   item_estoque item_estoque_id_produto_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_estoque
    ADD CONSTRAINT item_estoque_id_produto_fkey FOREIGN KEY (id_produto) REFERENCES public.produto(id_produto);
 S   ALTER TABLE ONLY public.item_estoque DROP CONSTRAINT item_estoque_id_produto_fkey;
       public          postgres    false    223    219    3219            �           2606    39719 '   item_estoque item_estoque_id_venda_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.item_estoque
    ADD CONSTRAINT item_estoque_id_venda_fkey FOREIGN KEY (id_venda) REFERENCES public.venda(id_venda);
 Q   ALTER TABLE ONLY public.item_estoque DROP CONSTRAINT item_estoque_id_venda_fkey;
       public          postgres    false    221    223    3221            �           2606    39690 "   produto produto_id_fornecedor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_id_fornecedor_fkey FOREIGN KEY (id_fornecedor) REFERENCES public.fornecedor(id_fornecedor);
 L   ALTER TABLE ONLY public.produto DROP CONSTRAINT produto_id_fornecedor_fkey;
       public          postgres    false    217    219    3217            �           2606    39702    venda venda_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente);
 E   ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_id_cliente_fkey;
       public          postgres    false    216    3215    221            <           0    39761    vwm_produto_estoque_06_06_2023    MATERIALIZED VIEW DATA     A   REFRESH MATERIALIZED VIEW public.vwm_produto_estoque_06_06_2023;
          public          postgres    false    226    3390            2   @   x����0�7�g�1a��?G��2��f��'d'G�6*��W��@�+vy�D�S�m����>      3   F   x����@�7
�%X�\�^��I��cNR�([�DK�s����H�O�B�b�v�W�x �PH      9   �   x�U��!��3��Am"l�u�Ë���'�I:��~7)ha��$Q`Va:C�4J	�ЀrQjB�%a��E)��ANYjB�%e�ӌR)4 ��V��Ђvi0�iG)��AN��q���:�6>,�	�^��f��1�f�~�7��&&��sr�Zk�n`9      1   %  x���N�0��W�ĵ��4��c Q�Z(B�uV�"�+�����}�fv{Z������*���8���1�d;
C{cpX��Y)����J��Wn�Z���׋qbR����nx�q+V�]��>^X{�;Y�LK��Hc~�p3q�ޓ
��:C.2QY#k/�����y�N�Ǣ�ρ�����*oia4>��U���8��w8��wL5�qvJ@ �\�Nv�t��se˺�g2�u�IH0.p�qJ�HB��Nos�HqN�[�(X�?�@��>�2%�ژ�Ǟ���o6      5   �   x�]�Aj�@E��)����x�m
�]u���pF�L��J��+T��z���~L�+�׼����M�À�IYoj�x&�P�U��� 	^�z�*����;#Ϣ���-f�;m1`�����M7��30������Q�d	>b����*�Q�XU�)bo|T���s���YT�g.���`���5��ڍ�qVr3�rG���&��<"�̳I�      7   M   x�M˱�0�Z�E�HY��K��#M��<��FSH�qCM�
i�(��h�9Q��0��X6�w�j*�hӣ�\ ^��      ;      x������ � �     