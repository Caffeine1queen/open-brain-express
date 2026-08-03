# Empieza aquí / Start here

**Abre Claude Code. Copia el bloque de abajo. Pégalo. Presiona Enter.**

Eso es todo lo que tienes que hacer para empezar. Claude se encarga del resto y
te va a ir pidiendo lo que necesite.

> *Open Claude Code, copy the block below, paste it, press Enter. That is the
> only thing you need to do to begin.*

---

```
Hola. Vas a acompañarme hoy a construir mi Open Brain.

IDIOMA: hablo español. Condúceme TODA la sesión en español — cada explicación,
cada pregunta, cada error que me traduzcas. Solo los comandos y el código se
quedan en inglés.

QUIÉN SOY: no soy técnico. Ya instalé algunas cosas hace unas semanas (Git,
Node, VS Code, Claude Code) y creé algunas cuentas, pero no me acuerdo bien de
qué quedó listo y qué no. Revisa antes de asumir.

CÓMO QUIERO QUE TRABAJES CONMIGO:

- Háblame como persona. Nada de tecnicismos sin explicarlos de inmediato.
- Haz el trabajo tú. No me expliques largamente lo que vas a hacer: hazlo y
  luego dime qué pasó, en una línea.
- Cuando necesites algo de mí, pídeme UNA cosa a la vez y espera.
- Dime al principio, y en serio, que te puedo preguntar lo que sea en cualquier
  momento — qué significa una palabra, qué acabas de hacer, si algo es seguro.
  Me dijeron que te pregunte a ti y no a la persona que me dio esto, porque
  aprender a preguntarte es justamente el punto del ejercicio.
- Si me quedo callado varios pasos, pregúntame si voy siguiendo.
- Si te pego un error o una captura de pantalla, trátalo como algo totalmente
  normal.
- NUNCA repitas una llave o contraseña mía en el chat. Guárdala donde va y dime
  "guardado", nada más.

ESTÁS AUTORIZADO A REPARAR: si un comando falla, lee el error, entiende la
causa, arregla el archivo e inténtalo otra vez. No te detengas a preguntarme qué
hacer — no voy a saber. Solo detente si ya intentaste dos veces y de verdad
estás atorado, y entonces explícamelo en español simple.

=== LO QUE VAMOS A HACER HOY ===

Construir una base de conocimiento personal que me pertenece: una aplicación web
donde guardo notas, voz, videos de YouTube, PDFs y artículos; una base de datos
mía; y al final, Claude Desktop leyendo todo lo que guardé.

=== EMPIEZA ASÍ ===

PASO 1 — Revisa qué tengo ya. Ejecuta y dime el resultado en español:
  git --version
  node --version

PASO 2 — Pregúntame, de una en una, cuáles de estas cuentas ya tengo:
  GitHub, Supabase, Vercel, OpenRouter, Claude Desktop

PASO 3 — Ayúdame a crear SOLO lo que me falte. Las instrucciones completas están
aquí, léelas antes de guiarme:
  https://raw.githubusercontent.com/King-Tuerto/open-brain-express/main/Sesion-1-Cuentas.md

Presta atención especial a dos cosas de ese documento:
  - Tengo que hacer "fork" del repositorio a mi propia cuenta de GitHub
  - Hay que DESACTIVAR "Confirm email" en Supabase (Authentication -> Sign In /
    Providers -> Email), o no voy a poder entrar a mi propia aplicación

PASO 4 — Cuando ya tenga todo, clona MI fork (no el original) y entra a la
carpeta:
  git clone https://github.com/MI_USUARIO/open-brain-express
  cd open-brain-express

PASO 5 — Abre el archivo Sesion-2-Construir.md que viene dentro de esa carpeta,
sigue sus instrucciones al pie de la letra, y constrúyeme el cerebro.

Cuando termines la Sesión 2, sigue con Sesion-3-Conectar.md.

Nota: usa siempre `npx supabase` para los comandos de Supabase. NO uses
`npm install -g supabase` — Supabase quitó el soporte para instalación global y
ese comando falla.

Empieza saludándome en español y diciéndome qué vamos a hacer.
```

---

## Si Claude Code no está abierto todavía

1. Abre la aplicación **Claude Code**
2. Elige o crea una carpeta donde vivirá el proyecto — el Escritorio está bien
3. Pega el bloque de arriba

Si algo de esto no te queda claro, esa misma pregunta pégasela a Claude. En
serio. Es lo que se supone que debes hacer.
