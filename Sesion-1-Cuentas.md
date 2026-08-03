# Sesión 1 — Cuentas y llaves

**Tiempo: 20 a 40 minutos. Esta es la única parte donde trabajas tú.**

Todo lo que viene después se hace solo. Esta parte no — crear cuentas significa
hacer clic en sitios web y leer tu propio correo, y ningún programa puede hacer
eso por ti.

Ve de arriba hacia abajo. Sáltate lo que ya tengas.

---

## Lee esto primero — es lo más importante

**Pregúntale todo a Claude. No le preguntes a la persona que te dio esto.**

No porque no quiera ayudarte. Sino porque aprender a preguntarle a la máquina
*es la construcción*. Todo lo demás que hagas aquí sale de ese hábito.

Vas a encontrarte con cosas que no entiendes. Una palabra que nunca has visto.
Un mensaje de error en rojo. Una pantalla que no se parece a lo que dice la
instrucción. Cada vez, haz lo mismo:

> **Dile a Claude exactamente lo que estás viendo y pregúntale qué hacer.**

No necesitas saber las palabras técnicas correctas. Todas estas funcionan:

- *"No entiendo qué es una llave API. Explícamelo como si no fuera técnico."*
- *"Me salió un error en rojo. Aquí está: [pégalo]. ¿Qué hago?"*
- *"Mi pantalla no se parece a lo que dicen las instrucciones."*
- *"Acabas de hacer algo. ¿Qué fue y por qué?"*
- *"¿Esto es seguro? ¿A qué le estoy dando permiso exactamente?"*
- *"Estoy perdido. ¿Dónde vamos y qué sigue?"*

Pega los mensajes de error completos. Toma una captura de pantalla y pégala.
Claude puede leer las dos cosas, y un error pegado tal cual sirve mucho más que
tratar de describirlo con palabras.

**Aquí no existen las preguntas tontas, y no puedes romper nada por
preguntar.** Lo peor que puede pasar es que te quedes callado sin entender, y
que todo esto se sienta como magia que no vas a poder repetir. La persona que
hoy hace cuarenta preguntas va a poder construir lo siguiente sola. La que
espera a que la rescaten, no.

Si te llevas una sola cosa de hoy, llévate esa.

---

## Qué estás construyendo, en un párrafo

Una base de conocimiento privada que te pertenece. Guardas cosas en ella —
notas escritas, ideas habladas, videos de YouTube, PDFs, artículos de internet —
y las almacena en una base de datos que es tuya. Ella sola descubre de qué trata
cada cosa, y conecta en silencio las ideas relacionadas entre sí. Después
apuntas a Claude hacia ella, y Claude puede buscar en todo lo que has guardado.
Si algún día dejas de usar Claude, el cerebro sigue funcionando — le apuntas
otra cosa.

---

## Antes de empezar — lo que ya deberías tener

Abre una ventana de comandos y escribe cada uno de estos. Estás buscando un
número de versión, no un error.

**Windows:** presiona Inicio, escribe `PowerShell`, presiona Enter.
**Mac:** presiona Cmd+Espacio, escribe `Terminal`, presiona Enter.

```bash
git --version
```

```bash
node --version
```

Si alguno da error, detente e instálalo primero —
[git-scm.com](https://git-scm.com/downloads) y [nodejs.org](https://nodejs.org)
(elige la versión LTS). Después cierra y vuelve a abrir la ventana de comandos.

También necesitas **Claude Code**. Si ya lo tienes, estás listo. Si no,
instálalo desde [claude.ai/download](https://claude.ai/download) — es la
aplicación que va a hacer la construcción de verdad.

---

## Unas palabras sobre las llaves API, antes de que crees una

Estás a punto de crear algo llamado llave API. Vale la pena entender qué es,
porque es lo único en toda esta construcción que cuesta dinero.

**Una llave API es una contraseña que permite que *tu programa* le hable a una
inteligencia artificial**, en lugar de que tú le hables escribiendo en un chat.

Aquí está la parte que confunde a casi todo el mundo:

> **Tu suscripción de Claude no cubre esto.**

Una suscripción de Claude Pro o Max paga para que *tú* uses Claude — en la app,
en el navegador, en Claude Code. No paga para que *tus programas* llamen a una
IA por su cuenta. Eso se cobra aparte, por uso. Son dos productos distintos con
dos cobros distintos. No se descompuso nada si te aparece una página de pago.

**Cuánto te va a costar de verdad:** cada vez que guardas algo, tu cerebro le
pide a una IA que lo etiquete y entienda de qué trata. Son peticiones chiquitas
y baratas. Guardar cincuenta cosas al mes cuesta bastante menos de un dólar.
Diez dólares de crédito probablemente te duren varios meses. No estás
contratando una suscripción — pones unos dólares y se van gastando conforme lo
usas.

Si guardas cien videos de YouTube en un fin de semana, vas a gastar más. Vas a
poder ver exactamente cuánto has gastado en el panel de tu proveedor en
cualquier momento.

---

## 1. GitHub — donde vive tu código

Sáltate el registro si ya tienes cuenta, pero **no te saltes el fork**.

1. Ve a [github.com](https://github.com) → **Sign up**
2. Cualquier nombre de usuario, plan gratuito
3. Verifica tu correo

### Después toma tu propia copia del código

1. Ve a **[github.com/King-Tuerto/open-brain-express](https://github.com/King-Tuerto/open-brain-express)**
2. Haz clic en **Fork** (arriba a la derecha)
3. Deja todo como está → **Create fork**

Ahora estás viendo tu propia copia — tu nombre de usuario aparece en la barra de
direcciones. El original se podría borrar mañana y la tuya no se vería afectada
para nada. Así funciona el código abierto, y significa que esto ya es tuyo de
verdad.

Deja esa pestaña abierta. La Sesión 2 va a necesitar la dirección.

---

## 2. Supabase — tu base de datos

Aquí es donde viven tus pensamientos de verdad. Es tuya; puedes exportar todo
cuando quieras.

1. Ve a [supabase.com](https://supabase.com) → **Start your project**
2. **Sign in with GitHub** — es lo más simple, y conecta las dos cuentas
3. Haz clic en **New project**
4. Ponle de nombre `open-brain`
5. Define una contraseña para la base de datos. **Guárdala en algún lado** — un
   gestor de contraseñas, una nota, donde la vuelvas a encontrar
6. Elige la región más cercana a ti
7. Haz clic en **Create new project** y espera como un minuto mientras se crea

### Después cambia una configuración — esto importa

Por defecto, Supabase te obliga a confirmar tu correo antes de poder entrar a tu
propia aplicación. Eso significa esperar un correo a la mitad de la instalación,
y es donde mucha gente se atora.

1. En tu proyecto, ve a **Authentication** en el menú de la izquierda
2. Busca **Sign In / Providers**, luego **Email**
3. **Desactiva** "Confirm email"
4. Guarda

Lo puedes volver a activar después. Para un cerebro personal donde solo entras
tú, no aporta nada.

---

## 3. OpenRouter — la IA que usa tu cerebro

Esta es la llave API de la que hablamos arriba. Es la única parte que se paga.

1. Ve a [openrouter.ai](https://openrouter.ai) → regístrate
2. Haz clic en tu avatar → **Credits** → agrega **$5 o $10 dólares**
3. Ve a **Keys** → **Create Key** → ponle de nombre `open-brain`
4. **Cópiala ahora.** Empieza con `sk-or-` y no te la van a volver a mostrar

Pégala en algún lugar seguro por los próximos veinte minutos — una app de notas
está bien. Pronto va a pasar al almacén de secretos de tu base de datos, y
después puedes borrar tu copia.

> **¿Por qué OpenRouter y no Anthropic directamente?** OpenRouter es una sola
> puerta a todos los modelos de IA — Claude, GPT, Gemini, los de código abierto.
> Una llave, una cuenta. Si algún día quieres cambiar qué IA mueve tu cerebro,
> cambias una palabra en un archivo de configuración. Ese es todo el punto de
> construirlo así: no estás amarrado a nadie.

---

## 4. Vercel — pone tu aplicación en internet

1. Ve a [vercel.com](https://vercel.com) → **Sign Up**
2. **Continue with GitHub**
3. Plan gratuito "Hobby"

---

## 5. Supadata — opcional, para YouTube

**Puedes saltarte esto. Todo funciona sin ello.**

YouTube esconde los subtítulos de los servidores a propósito. Tu cerebro trae
una solución bastante lista que funciona buena parte del tiempo por su cuenta.
Supadata es un servicio que consigue las transcripciones de forma confiable, y
su plan gratuito cubre 100 videos al mes.

Sin él: las capturas de YouTube siguen funcionando, pero a veces vas a recibir
un resumen de la descripción del video en lugar de lo que realmente se dijo.

1. Ve a [supadata.ai](https://supadata.ai) → regístrate
2. Copia tu llave API

---

## 6. Claude Desktop — para la recompensa del final

1. Ve a [claude.ai/download](https://claude.ai/download)
2. Instálalo e inicia sesión

Esto es lo que va a leer tu cerebro en la Sesión 3.

---

## Lista de verificación — estás listo cuando todo esto sea cierto

- [ ] `git --version` muestra un número de versión
- [ ] `node --version` muestra un número de versión
- [ ] Claude Code está instalado
- [ ] Puedes entrar a **github.com**
- [ ] Hiciste **fork** de open-brain-express a tu cuenta
- [ ] Tu proyecto de Supabase existe y muestra un panel
- [ ] "Confirm email" está **desactivado** en Authentication de Supabase
- [ ] Tienes tu **llave de OpenRouter** (`sk-or-…`) anotada
- [ ] Puedes entrar a **vercel.com**
- [ ] Claude Desktop está instalado
- [ ] *(opcional)* Tienes una llave de Supadata

---

## Sigue

Abre la **Sesión 2**. Ahí dejas de trabajar y empiezas a ver.
