# FORNO ROSSO

Sitio web responsivo inspirado en el sistema de diseño y las pantallas de Stitch proporcionados. Es una web estática con HTML, CSS y JavaScript, lista para GitHub Pages o Vercel y sin paso de compilación.

## Ejecutar en local

Abre `index.html` en un navegador. La carta, los filtros, el carrito, los pedidos, las reservaciones y el panel de operaciones funcionan en modo local y guardan información en el almacenamiento del navegador.

Para probar la sincronización con Supabase, sirve la carpeta con cualquier servidor estático local. Por ejemplo, desde VS Code puedes usar Live Server. En Vercel, conecta el repositorio y publica la carpeta raíz; no hace falta un comando de build.

## Publicar

1. Crea un repositorio y sube los archivos del proyecto.
2. En Vercel, importa el repositorio y usa la configuración de sitio estático, con `index.html` como entrada y sin comando de build.
3. Para usar otro proveedor estático, la carpeta raíz es el sitio completo.

## Activar Supabase

1. Crea un proyecto en Supabase y ejecuta [`supabase-schema.sql`](supabase-schema.sql) en SQL Editor.
2. Crea las cuentas del equipo en Authentication y agrega sus UUID a `public.admin_users` con la instrucción comentada al final del esquema. Solo esas cuentas podrán consultar o actualizar pedidos y consultar reservaciones.
3. Copia la URL del proyecto y la clave **anon/publishable** a [`config.js`](config.js). Nunca uses una clave `service_role` en archivos públicos.
4. Sustituye también el número de muestra `50400000000` por el WhatsApp del restaurante.
5. Sirve la página desde `http://localhost` o tu dominio publicado. El navegador requiere HTTP/HTTPS para comunicarse con Supabase.

El sitio puede guardar pedidos y solicitudes sin conexión a Supabase. Cuando se configura, los envía también a Supabase; el panel permite iniciar sesión, sincronizar y cambiar el estado de cada pedido. WhatsApp sigue siendo el canal de confirmación con el cliente. El precio de entrega, los pagos en línea, la disponibilidad de mesas y la confirmación automática aún requieren reglas y servicios propios del restaurante.

## Archivos principales

- `index.html`: sitio público, carta, carrito y reservaciones.
- `admin.html`: panel de pedidos y solicitudes de mesa.
- `styles.css`: tokens del sistema visual y diseños responsive.
- `app.js`: filtros, carrito, pedidos, formularios, administración y conexión REST a Supabase.
- `config.js`: configuración pública de Supabase y número de WhatsApp.
- `supabase-schema.sql`: tablas, permisos y políticas de acceso.
