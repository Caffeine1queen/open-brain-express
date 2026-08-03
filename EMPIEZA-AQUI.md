# Empieza aquí

*[English version: START-HERE.md](START-HERE.md)*

---

## Paso 0 — Necesitas tres cosas instaladas

Esto es lo único que no se puede automatizar, porque son programas que tienen
que existir antes de que Claude pueda ayudarte. Toma unos 15 minutos y solo se
hace una vez.

**Si ya hiciste esto antes, sáltate al Paso 1.**

### 1. Claude Code
[claude.ai/download](https://claude.ai/download) — descárgalo, instálalo, inicia
sesión. Esta es la aplicación que va a construir todo.

Necesitas una suscripción de Claude (Pro o Max) para usarlo.

### 2. Node.js
[nodejs.org](https://nodejs.org) — descarga la versión que dice **LTS**. Instala
aceptando todo lo que trae por defecto.

### 3. Git
[git-scm.com/downloads](https://git-scm.com/downloads) — instala aceptando todo
lo que trae por defecto.

*(En Mac, escribir `git --version` en la Terminal muchas veces lo instala solo.)*

### Comprueba que quedó

Abre una ventana de comandos:
- **Windows:** presiona Inicio, escribe `PowerShell`, Enter
- **Mac:** presiona Cmd+Espacio, escribe `Terminal`, Enter

Escribe estas dos líneas, una a la vez. Buscas números de versión, no errores:

```bash
git --version
```

```bash
node --version
```

Si las dos responden con un número, ya estás. Si alguna da error, vuelve a
instalar esa e intenta otra vez.

---

## Paso 1 — Un solo prompt

**Abre Claude Code, elige o crea una carpeta (el Escritorio está bien), copia
todo el bloque de abajo, pégalo y presiona Enter.**

Eso es todo lo que tienes que hacer para empezar. Claude se encarga del resto y
te va a ir pidiendo lo que necesite.

```
Hola. Vas a acompañarme hoy a construir mi Open Brain.

IDIOMA: hablo español. Condúceme TODA la sesión en español — cada explicación,
cada pregunta, cada error que me traduzcas. Solo los comandos y el código se
quedan en inglés.

QUIÉN SOY: no soy técnico. No des por hecho lo que ya tengo instalado o qué
cuentas ya existen: revísalo y pregúntame. Puede que tenga todo, puede que no
tenga nada, puede que haya hecho algo hace semanas y ya no me acuerde.

CÓMO QUIERO QUE TRABAJES CONMIGO:

- Háblame como persona. Nada de tecnicismos sin explicarlos de inmediato.
- Haz el trabajo tú. No me expliques largamente lo que vas a hacer: hazlo y
  luego dime qué pasó, en una línea.
- Cuando necesites algo de mí, pídeme UNA cosa a la vez y espera.
- Dime al principio, y en serio, que te puedo preguntar lo que sea en cualquier
  momento — qué significa una palabra, qué acabas de hacer, si algo es seguro.
  Aprender a preguntarte es justamente el punto del ejercicio.
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

Si alguno falla, ayúdame a instalarlo antes de seguir.

PASO 2 — Pregúntame, de una en una, cuáles de estas cuentas ya tengo:
  GitHub, Supabase, Vercel, OpenRouter, Claude Desktop

PASO 3 — Ayúdame a crear SOLO lo que me falte. Las instrucciones completas están
aquí, léelas antes de guiarme:
  https://raw.githubusercontent.com/King-Tuerto/open-brain-express/main/Sesion-1-Cuentas.md

Presta atención especial a tres cosas de ese documento:
  - Tengo que hacer "fork" del repositorio a mi propia cuenta de GitHub
  - Hay que DESACTIVAR "Confirm email" en Supabase (Authentication -> Sign In /
    Providers -> Email), o no voy a poder entrar a mi propia aplicación
  - La llave de OpenRouter es la única parte que cuesta dinero. Explícame bien
    qué es y cuánto va a costarme antes de que ponga una tarjeta.

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

## ¿Cuánto tiempo toma?

| | |
|---|---|
| Paso 0 (instalar) | ~15 min, una sola vez |
| Cuentas | 20–40 min |
| Construcción | 45–90 min, casi todo esperando |
| Conectar Claude y llenar el cerebro | ~90 min |

No tienes que hacerlo todo el mismo día. Puedes parar después de la Sesión 2 y
seguir otro día — lo que construiste se queda ahí.

---

## Si algo no te queda claro

Pégale esa misma pregunta a Claude. En serio. Es lo que se supone que debes
hacer, y es lo más valioso que te vas a llevar de todo esto.
