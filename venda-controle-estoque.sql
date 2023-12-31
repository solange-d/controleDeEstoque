PGDMP                         {            venda    15.2    15.1 (    %           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            &           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            '           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            (           1262    39562    venda    DATABASE     |   CREATE DATABASE venda WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE venda;
                postgres    false            �            1255    39651    baixaestoque()    FUNCTION     �   CREATE FUNCTION public.baixaestoque() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE produto SET estoque = estoque - 1
    WHERE id_produto = NEW.id_produto;
    RETURN NEW;
END;
$$;
 %   DROP FUNCTION public.baixaestoque();
       public          postgres    false            �            1255    39653    verificar_estoque()    FUNCTION     )  CREATE FUNCTION public.verificar_estoque() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (SELECT estoque FROM produto WHERE id_produto = NEW.id_produto) < 1 THEN
        RAISE EXCEPTION 'Não é possível adicionar venda. Estoque insuficiente.';
    END IF;
    RETURN NEW;
END;
$$;
 *   DROP FUNCTION public.verificar_estoque();
       public          postgres    false            �            1259    39570    cliente    TABLE     `   CREATE TABLE public.cliente (
    id_cliente integer NOT NULL,
    cpf character varying(11)
);
    DROP TABLE public.cliente;
       public         heap    postgres    false            �            1259    39580 
   fornecedor    TABLE     g   CREATE TABLE public.fornecedor (
    id_fornecedor integer NOT NULL,
    cnpj character varying(14)
);
    DROP TABLE public.fornecedor;
       public         heap    postgres    false            �            1259    39564    pessoa    TABLE     �   CREATE TABLE public.pessoa (
    id_pessoa integer NOT NULL,
    nome character varying(100) NOT NULL,
    endereco character varying(100) NOT NULL
);
    DROP TABLE public.pessoa;
       public         heap    postgres    false            �            1259    39563    pessoa_id_pessoa_seq    SEQUENCE     �   CREATE SEQUENCE public.pessoa_id_pessoa_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.pessoa_id_pessoa_seq;
       public          postgres    false    215            )           0    0    pessoa_id_pessoa_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.pessoa_id_pessoa_seq OWNED BY public.pessoa.id_pessoa;
          public          postgres    false    214            �            1259    39591    produto    TABLE     �   CREATE TABLE public.produto (
    id_produto integer NOT NULL,
    id_fornecedor integer NOT NULL,
    nome character varying(100) NOT NULL,
    preco double precision NOT NULL,
    estoque integer
);
    DROP TABLE public.produto;
       public         heap    postgres    false            �            1259    39590    produto_id_produto_seq    SEQUENCE     �   CREATE SEQUENCE public.produto_id_produto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.produto_id_produto_seq;
       public          postgres    false    219            *           0    0    produto_id_produto_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE public.produto_id_produto_seq OWNED BY public.produto.id_produto;
          public          postgres    false    218            �            1259    39603    venda    TABLE     �   CREATE TABLE public.venda (
    id_venda integer NOT NULL,
    id_cliente integer NOT NULL,
    data_hora date NOT NULL,
    id_produto integer
);
    DROP TABLE public.venda;
       public         heap    postgres    false            �            1259    39602    venda_id_venda_seq    SEQUENCE     �   CREATE SEQUENCE public.venda_id_venda_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.venda_id_venda_seq;
       public          postgres    false    221            +           0    0    venda_id_venda_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE public.venda_id_venda_seq OWNED BY public.venda.id_venda;
          public          postgres    false    220            y           2604    39567    pessoa id_pessoa    DEFAULT     t   ALTER TABLE ONLY public.pessoa ALTER COLUMN id_pessoa SET DEFAULT nextval('public.pessoa_id_pessoa_seq'::regclass);
 ?   ALTER TABLE public.pessoa ALTER COLUMN id_pessoa DROP DEFAULT;
       public          postgres    false    215    214    215            z           2604    39594    produto id_produto    DEFAULT     x   ALTER TABLE ONLY public.produto ALTER COLUMN id_produto SET DEFAULT nextval('public.produto_id_produto_seq'::regclass);
 A   ALTER TABLE public.produto ALTER COLUMN id_produto DROP DEFAULT;
       public          postgres    false    218    219    219            {           2604    39606    venda id_venda    DEFAULT     p   ALTER TABLE ONLY public.venda ALTER COLUMN id_venda SET DEFAULT nextval('public.venda_id_venda_seq'::regclass);
 =   ALTER TABLE public.venda ALTER COLUMN id_venda DROP DEFAULT;
       public          postgres    false    220    221    221                      0    39570    cliente 
   TABLE DATA           2   COPY public.cliente (id_cliente, cpf) FROM stdin;
    public          postgres    false    216   �-                 0    39580 
   fornecedor 
   TABLE DATA           9   COPY public.fornecedor (id_fornecedor, cnpj) FROM stdin;
    public          postgres    false    217   0.                 0    39564    pessoa 
   TABLE DATA           ;   COPY public.pessoa (id_pessoa, nome, endereco) FROM stdin;
    public          postgres    false    215   �.                  0    39591    produto 
   TABLE DATA           R   COPY public.produto (id_produto, id_fornecedor, nome, preco, estoque) FROM stdin;
    public          postgres    false    219   �/       "          0    39603    venda 
   TABLE DATA           L   COPY public.venda (id_venda, id_cliente, data_hora, id_produto) FROM stdin;
    public          postgres    false    221   �0       ,           0    0    pessoa_id_pessoa_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.pessoa_id_pessoa_seq', 10, true);
          public          postgres    false    214            -           0    0    produto_id_produto_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('public.produto_id_produto_seq', 10, true);
          public          postgres    false    218            .           0    0    venda_id_venda_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.venda_id_venda_seq', 10, true);
          public          postgres    false    220                       2606    39574    cliente cliente_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id_cliente);
 >   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_pkey;
       public            postgres    false    216            �           2606    39584    fornecedor fornecedor_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.fornecedor
    ADD CONSTRAINT fornecedor_pkey PRIMARY KEY (id_fornecedor);
 D   ALTER TABLE ONLY public.fornecedor DROP CONSTRAINT fornecedor_pkey;
       public            postgres    false    217            }           2606    39569    pessoa pessoa_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.pessoa
    ADD CONSTRAINT pessoa_pkey PRIMARY KEY (id_pessoa);
 <   ALTER TABLE ONLY public.pessoa DROP CONSTRAINT pessoa_pkey;
       public            postgres    false    215            �           2606    39596    produto produto_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id_produto);
 >   ALTER TABLE ONLY public.produto DROP CONSTRAINT produto_pkey;
       public            postgres    false    219            �           2606    39608    venda venda_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_pkey PRIMARY KEY (id_venda);
 :   ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_pkey;
       public            postgres    false    221            �           2620    39652    venda atualizarestoque    TRIGGER     r   CREATE TRIGGER atualizarestoque AFTER INSERT ON public.venda FOR EACH ROW EXECUTE FUNCTION public.baixaestoque();
 /   DROP TRIGGER atualizarestoque ON public.venda;
       public          postgres    false    221    222            �           2620    39654    venda validar_estoque    TRIGGER     w   CREATE TRIGGER validar_estoque BEFORE INSERT ON public.venda FOR EACH ROW EXECUTE FUNCTION public.verificar_estoque();
 .   DROP TRIGGER validar_estoque ON public.venda;
       public          postgres    false    223    221            �           2606    39575    cliente cliente_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.pessoa(id_pessoa);
 I   ALTER TABLE ONLY public.cliente DROP CONSTRAINT cliente_id_cliente_fkey;
       public          postgres    false    3197    216    215            �           2606    39585 (   fornecedor fornecedor_id_fornecedor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.fornecedor
    ADD CONSTRAINT fornecedor_id_fornecedor_fkey FOREIGN KEY (id_fornecedor) REFERENCES public.pessoa(id_pessoa);
 R   ALTER TABLE ONLY public.fornecedor DROP CONSTRAINT fornecedor_id_fornecedor_fkey;
       public          postgres    false    217    215    3197            �           2606    39631    venda id_produto    FK CONSTRAINT     |   ALTER TABLE ONLY public.venda
    ADD CONSTRAINT id_produto FOREIGN KEY (id_produto) REFERENCES public.produto(id_produto);
 :   ALTER TABLE ONLY public.venda DROP CONSTRAINT id_produto;
       public          postgres    false    219    221    3203            �           2606    39597 "   produto produto_id_fornecedor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_id_fornecedor_fkey FOREIGN KEY (id_fornecedor) REFERENCES public.fornecedor(id_fornecedor);
 L   ALTER TABLE ONLY public.produto DROP CONSTRAINT produto_id_fornecedor_fkey;
       public          postgres    false    217    3201    219            �           2606    39609    venda venda_id_cliente_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.venda
    ADD CONSTRAINT venda_id_cliente_fkey FOREIGN KEY (id_cliente) REFERENCES public.cliente(id_cliente);
 E   ALTER TABLE ONLY public.venda DROP CONSTRAINT venda_id_cliente_fkey;
       public          postgres    false    221    3199    216               @   x����0�7�g�1a��?G��2��f��'d'G�6*��W��@�+vy�D�S�m����>         F   x����@�7
�%X�\�^��I��cNR�([�DK�s����H�O�B�b�v�W�x �PH         %  x���N�0��W�ĵ��4��c Q�Z(B�uV�"�+�����}�fv{Z������*���8���1�d;
C{cpX��Y)����J��Wn�Z���׋qbR����nx�q+V�]��>^X{�;Y�LK��Hc~�p3q�ޓ
��:C.2QY#k/�����y�N�Ǣ�ρ�����*oia4>��U���8��w8��wL5�qvJ@ �\�Nv�t��se˺�g2�u�IH0.p�qJ�HB��Nos�HqN�[�(X�?�@��>�2%�ژ�Ǟ���o6          �   x�]�Aj�0E�N�ɉly[�B�-CW�Lc��N��[�z�N�������C���q�M��{�@{͞�n<��͜��7^�!R@�1�������s�j8���Ϸ��򩲚l�Cz<V.����"h�킒�5�tI��ƫ����������W�?���A�'Y�u�yg�.ySw@C�>
��)W6S��c����l�&�W~LY��<��,���{8z�D��iM      "   k   x�e���PDѵ݋#��}�	*��:�$rl�tG��I�0_eߔ%0�����%���0R�Ŀ�)�$,<eJ{�,7q���KxU�"�_����yy�O�+��xS{��U= �m,     