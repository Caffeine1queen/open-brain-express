# Sesión 3 — Conectar Claude y llenar tu cerebro

**Tiempo: unos 90 minutos. La mitad es la parte divertida.**

Aquí pasan dos cosas. Primero conectas Claude Desktop a tu cerebro, lo que toma
como quince minutos. Después lo llenas — porque un cerebro con tres cosas
adentro no impresiona a nadie, y uno con treinta sí.

---

## Parte A — Conectar Claude

**Copia el bloque de abajo y pégalo en Claude Code.**

> Igual que en la Sesión 2: el bloque está en inglés porque son instrucciones
> técnicas. Claude te va a hablar en español.

```
IMPORTANT — LANGUAGE: The person you are working with speaks Spanish. Conduct
this entire session in Spanish. Only commands and code stay in English.

Connect this person's Open Brain to their Claude Desktop app.

You need two values, both of which should be in `.env.local` from Session 2:
  - Their Supabase project ref
  - Their MCP_ACCESS_KEY

If either is missing, ask for it.

=== STEP 1 — CHECK THE SERVER RESPONDS ===

Before touching Claude Desktop, confirm the MCP server is alive:

  curl -X POST https://THEIR_REF.supabase.co/functions/v1/open-brain-mcp ^
    -H "Content-Type: application/json" ^
    -H "Authorization: Bearer THEIR_MCP_ACCESS_KEY" ^
    -d "{\"jsonrpc\":\"2.0\",\"id\":1,\"method\":\"tools/list\",\"params\":{}}"

(On Mac or Linux use \ instead of ^ for line continuation.)

You want a response listing three tools: search_brain, list_recent, add_thought.

If you get 401: the key does not match what is in Supabase secrets.
If you get a Supabase gateway error rather than your own 401: the function was
deployed without --no-verify-jwt. Redeploy it with that flag.

=== STEP 2 — WRITE THE CLAUDE DESKTOP CONFIG ===

Find the config file:
  Windows: %APPDATA%\Claude\claude_desktop_config.json
  Mac:     ~/Library/Application Support/Claude/claude_desktop_config.json

If it does not exist, create it. If it does exist, MERGE into it — do not
overwrite it, they may have other MCP servers configured already.

The entry to add:

{
  "mcpServers": {
    "open-brain": {
      "command": "npx",
      "args": [
        "-y",
        "mcp-remote",
        "https://THEIR_REF.supabase.co/functions/v1/open-brain-mcp",
        "--header",
        "Authorization:${AUTH_TOKEN}"
      ],
      "env": {
        "AUTH_TOKEN": "Bearer THEIR_MCP_ACCESS_KEY"
      }
    }
  }
}

Note the shape of that header: `Authorization:${AUTH_TOKEN}` with no space after
the colon, and the actual value in `env`. This looks odd but it is deliberate —
arguments containing spaces get mangled on Windows, and this form avoids it.

Validate the file is proper JSON before saving. A stray comma here means Claude
Desktop starts with no tools and says nothing about why.

=== STEP 3 — RESTART CLAUDE DESKTOP ===

Tell them, in Spanish, to quit Claude Desktop COMPLETELY — not just close the
window. On Windows, right-click the system tray icon and choose Quit. On Mac,
Cmd+Q. Then reopen it.

Have them start a new conversation and check for a tools or slider icon near the
message box. Clicking it should list open-brain.

=== STEP 4 — TEST IT ===

Have them ask Claude Desktop, in Spanish, in their own words:

  "Busca en mi cerebro [algo que guardaron en la Sesión 2]"

Claude should call search_brain and return their own thought.

If nothing happens, check in this order:
  1. Was Claude Desktop fully quit and reopened?
  2. Is the JSON valid?
  3. Does the curl test from Step 1 still work?
  4. Look at Claude Desktop's MCP logs:
     Windows: %APPDATA%\Claude\logs\
     Mac:     ~/Library/Logs/Claude/
```

---

## Parte B — Llenar tu cerebro

Esta es la parte que la gente se salta, y es la que decide si vas a seguir
usando esto o si para el viernes ya se te olvidó.

Ahorita tu cerebro tiene un puñado de cosas. Buscar ahí es decepcionante, porque
no hay nada que valga la pena encontrar. **Veinte minutos alimentándolo cambian
eso por completo.**

Haz las tres cosas de abajo. En ese orden.

### 1. Cinco a ocho videos de YouTube — unos dos minutos

Piensa en videos que de verdad hayas visto en los últimos meses y que te hayan
enseñado algo. Una charla, un tutorial, una entrevista, un documental.

Búscalos en tu historial de YouTube y pega cada liga en la pestaña **YouTube**.

Es la forma más rápida de llenar un cerebro con sustancia. Cada video se
convierte en varios párrafos de contenido real — vale muchísimo más que una
docena de notas de una línea.

### 2. Tres a cinco ligas — unos dos minutos

Artículos que guardaste y pensabas leer. Publicaciones a las que vuelves seguido.
Lo que tengas en una pestaña abierta ahorita.

Pega cada una en la pestaña **Link**.

### 3. Una conversación de quince minutos — la importante

Aquí es donde se vuelve *tuyo* y deja de ser un montón de contenido de otros.

Abre Claude Desktop — ya puede escribir en tu cerebro — y pega esto:

```
Entrevístame para llenar mi Open Brain con lo que de verdad sé y me importa.

Hazme una pregunta a la vez y espera mi respuesta. Después de cada respuesta,
usa la herramienta add_thought para guardarla con mis propias palabras —
ordenadas, pero sin convertirlas en lenguaje corporativo.

Cubre más o menos estos temas, siguiendo cualquier cosa interesante que diga:
- En qué estoy trabajando ahorita y qué es lo difícil de eso
- Algo que aprendí hace poco que me cambió la forma de pensar
- Un problema que llevo rato masticando sin resolver
- Algo que me encuentro explicándole a la gente una y otra vez
- En qué quiero ser mejor de aquí a un año
- Opiniones que tengo con las que la gente a mi alrededor no está de acuerdo

Sigue como quince minutos. No hagas un resumen al final — solo ve guardando
sobre la marcha, y al terminar dime cuántos pensamientos capturamos.
```

Habla normal. No trates de sonar impresionante. Los pensamientos a medio formar
son los valiosos — esos son justo los que se te van a haber olvidado en seis
meses.

---

## Ahora úsalo

Deberías tener unos treinta y tantos pensamientos. Prueba esto en Claude Desktop:

> **"¿En qué he estado pensando últimamente?"**
> Lee tus capturas recientes y te lo dice — muchas veces nota patrones que tú no
> habías notado.

> **"Busca en mi cerebro cómo conseguir clientes nuevos"** — usando palabras que
> nunca escribiste. Debería encontrar de todos modos tus notas sobre captación,
> mercadotecnia o ventas. Eso es la búsqueda por significado funcionando.

> **"¿Qué se conecta con lo que guardé sobre [tema]?"**
> Ese es el grafo. Ideas que habías olvidado resurgen porque están conectadas con
> lo que estás pensando ahora.

> **"Con base en todo lo que hay en mi cerebro, ¿qué estoy evitando?"**
> Haz esta cuando ya tengas más adentro. Es incómoda.

---

## Mantenerlo vivo

El cerebro vale lo que le metas. El hábito que hace que funcione:

**Cuando termines algo que valga la pena recordar — un video, un artículo, una
conversación, una idea en la regadera — métela.** Diez segundos. La app en el
celular lo hace fácil: abre la dirección en el navegador del teléfono y elige
"Agregar a pantalla de inicio".

En tres meses vas a tener algo que ninguna IA te puede dar desde su propio
entrenamiento: todo lo que *tú* consideraste que valía la pena guardar, buscable
por significado, conectado consigo mismo, y legible por la IA que estés usando en
ese momento.

Ese es todo el punto. Es tuyo.
