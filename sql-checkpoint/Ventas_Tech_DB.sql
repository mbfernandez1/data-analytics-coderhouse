create database Ventas_Tech_DB;

use Ventas_Tech_DB;

drop table if exists ventas;
drop table if exists productos;
drop table if exists clientes;
drop table if exists categorias;

create table categorias (
id_categorias int primary key,
nombre_categoria varchar (50) not null,
descripcion varchar (200)
);

create table Clientes (
id_cliente int primary key,
nombre varchar (100) not null,
email varchar (100) unique,
ciudad varchar (100),
fecha_registro date not null
);

exec sp_rename 'categorias.id_categorias', 'id_categoria', 'column';

create table Productos (
id_producto int primary key,
nombre_producto varchar (100) not null,
id_categoria int not null,
precio decimal (10,2) not null,
stock int default 0,
activo int default 1,
foreign key (id_categoria) references categorias (id_categoria)
);

create table Ventas (
id_venta int primary key,
id_cliente int not null,
id_producto int not null,
cantidad int not null,
precio_unitario decimal (10,2) not null,
fecha_venta date not null,
foreign key (id_cliente) references Clientes(id_cliente),
foreign key (id_producto) references Productos(id_producto)
);

insert into categorias (id_categoria, nombre_categoria, descripcion) values
(1, 'Computación', 'Laptops, PCs y monitores'),
(2, 'Accesorios', 'Periféricos y complementos'),
(3, 'Audio', 'Auriculares y parlantes'),
(4, 'Almacenamiento', 'Discos y memorias');

INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES 
(1, 'María López',   'maria@mail.com',   'Buenos Aires', '2024-01-05'),
(2, 'Carlos Ruiz',   'carlos@mail.com',  'Córdoba',      '2024-01-10'),
(3, 'Ana Gómez',     'ana@mail.com',     'Rosario',      '2024-02-01'),
(4, 'Pedro Sanz',    'pedro@mail.com',   'Mendoza',      '2024-02-15'),
(5, 'Laura Torres',  'laura@mail.com',   'Tucumán',      '2024-03-01');

INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES 
(1, 'Laptop Pro 15',       1, 1200.00, 15, 1),
(2, 'Mouse Inalámbrico',   2,   28.00, 80, 1),
(3, 'Monitor 4K 27"',      1,  450.00, 12, 1),
(4, 'Auriculares BT Pro',  3,  120.00, 35, 1),
(5, 'SSD Externo 1TB',     4,  130.00, 18, 1),
(6, 'Teclado Mecánico',    2,   95.00, 40, 1);

INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES 
(1,  1, 1, 2, 1200.00, '2024-03-05'),
(2,  2, 2, 5,   28.00, '2024-03-06'),
(3,  3, 3, 1,  450.00, '2024-03-07'),
(4,  1, 4, 2,  120.00, '2024-03-08'),
(5,  4, 5, 3,  130.00, '2024-03-10'),
(6,  2, 6, 4,   95.00, '2024-03-11'),
(7,  5, 1, 1, 1200.00, '2024-03-12'),
(8,  3, 2, 8,   28.00, '2024-03-13'),
(9,  4, 4, 1,  120.00, '2024-03-14'),
(10, 5, 3, 2,  450.00, '2024-03-15');

select*from categorias;
select*from clientes;
select*from productos;
select*from ventas;