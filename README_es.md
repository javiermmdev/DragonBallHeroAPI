
# DragonBallHeroAPI

KCDragonBall es una aplicación iOS creada en Swift que permite a los usuarios explorar los personajes de Dragon Ball y sus transformaciones. La aplicación usa `UICollectionView` para mostrar personajes, integra JWT para la autenticación de inicio de sesión, y se comunica con una API remota para obtener datos de personajes y transformaciones.

Este README también está disponible en:
- [English](README.md)

## Características
- Inicio de sesión de usuarios con autenticación basada en JWT.
- Mostrar personajes en una lista desplazable.
- Ver detalles de un personaje seleccionado, incluidas sus transformaciones.
- Carga de imágenes de personajes de forma asíncrona.
- Funcionalidad de cierre de sesión con gestión segura del token.

## Requisitos
- Xcode 12.0 o posterior.
- iOS 13.0 o posterior.
- Swift 5.0 o posterior.

## Instalación

Para configurar el proyecto localmente, sigue estos pasos:

1. Clona el repositorio:
   ```bash
   git clone https://github.com/javiermmdev/DragonBallHeroAPI.git
   cd KCDragonBall
   ```

2. Abre el proyecto en Xcode:
   ```bash
   open KCDragonBall.xcodeproj
   ```

3. Compila y ejecuta la aplicación en un simulador o dispositivo físico.

## Estructura del Proyecto

El proyecto sigue el patrón de diseño Modelo-Vista-Controlador (MVC), estructurado de la siguiente manera:

```
.
├── Models
│   ├── Hero.swift                 # Modelo que representa un personaje de Dragon Ball
│   ├── Transformation.swift       # Modelo que representa las transformaciones de los personajes
├── Views
│   ├── CharacterCollectionViewCell.swift   # Celda de vista de colección para personajes
│   ├── TransformationCollectionViewCell.swift # Celda de vista de colección para transformaciones
├── ViewControllers
│   ├── CharacterViewController.swift   # Controlador de vista principal que muestra personajes
│   ├── CharacterDataViewController.swift # Controlador de vista detallada para un personaje seleccionado
│   ├── TransformationViewController.swift  # Controlador de vista para mostrar transformaciones
│   ├── loginHeroViewController.swift  # Controlador de vista de pantalla de inicio de sesión
├── Network
│   ├── NetworkModel.swift        # Administra las solicitudes de red y el manejo de tokens
│   ├── APIClient.swift           # Cliente API para realizar solicitudes HTTP
│   ├── APIClientProtocol.swift   # Protocolo para el cliente API
│   ├── APIClientProtocolMock.swift  # Implementación mock para pruebas
├── Tests
│   ├── NetworkModelTests.swift   # Pruebas unitarias para NetworkModel
├── Resources
│   ├── Assets.xcassets            # Activos de la aplicación como imágenes e íconos
│   ├── LaunchScreen.storyboard    # Pantalla de inicio de la UI
├── SceneDelegate.swift            # Maneja la navegación basada en el estado de inicio de sesión
└── AppDelegate.swift              # Delegado de la aplicación
```

## Uso

### 1. **Inicio de Sesión**:
Al iniciar la aplicación, se le solicita al usuario una pantalla de inicio de sesión. Si se ingresan credenciales válidas, la aplicación recupera un token JWT y lo almacena de forma segura.

[![Login](https://i.imgur.com/oyKDTIa.png)](https://i.imgur.com/3ScrPfC.png)

Si el inicio de sesión falla, se muestra un mensaje de error.

[![Login Failed](https://i.imgur.com/GrUr2nM.png)](https://i.imgur.com/XNy3Fi5.png)

### 2. **Lista de Personajes**:
Después de iniciar sesión, la aplicación muestra una lista desplazable de personajes de Dragon Ball, cada uno con una imagen y descripción.

[![Hero Page](https://i.imgur.com/kLLHZoU.png)](https://i.imgur.com/wjtnxqq.png)

### 3. **Detalle del Personaje**:
Al hacer clic en un personaje, se abre una pantalla detallada que incluye su descripción y, si corresponde, sus transformaciones.

#### Personaje sin Transformaciones:
[![Hero with no transformations](https://i.imgur.com/GvyQ2iy.png)](https://i.imgur.com/EmoDkqW.png)

#### Personaje con Transformaciones:
[![Hero with transformations](https://i.imgur.com/cEm8l0H.png)](https://i.imgur.com/LlN1iAv.png)

### 4. **Transformaciones**:
Si el personaje seleccionado tiene transformaciones, el usuario puede verlas en una pantalla separada.

[![Transformations](https://i.imgur.com/yUsDLti.png)](https://i.imgur.com/FY7pIT6.png)

### 5. **Detalles de la Transformación**:
Al seleccionar una transformación de la lista, los usuarios pueden ver más detalles sobre ella.

[![Transformation Details](https://i.imgur.com/SgRfdrE.png)](https://i.imgur.com/xMW6TCU.png)

### 6. **Cierre de Sesión**:
Los usuarios pueden cerrar sesión haciendo clic en el botón de cierre de sesión en la pantalla principal de personajes.

## Pruebas

Las pruebas unitarias se escriben utilizando `XCTest`. Para ejecutar las pruebas:

1. Abre el proyecto en Xcode.
2. Selecciona el menú `Producto` y haz clic en `Probar` (o presiona `Cmd+U`).
3. Alternativamente, ejecuta las pruebas utilizando el navegador de pruebas de Xcode.

El conjunto de pruebas incluye:

- **NetworkModelTests.swift**: Verifica el comportamiento de las solicitudes de red, incluida la funcionalidad de inicio de sesión, la obtención de héroes y el manejo de errores de red. Se utilizan objetos mock para simular respuestas de API sin realizar solicitudes reales.

## Puntos de API

La aplicación se comunica con los siguientes puntos de la API:

- **Inicio de Sesión**: `/api/auth/login` (POST)
- **Obtener Héroes**: `/api/heros/all` (POST)
- **Obtener Transformaciones**: `/api/heros/tranformations` (POST)

Cada solicitud está autenticada utilizando un token Bearer obtenido durante el proceso de inicio de sesión.

## Tecnologías Utilizadas

- **Swift 5**
- **UIKit**: Para construir la interfaz de usuario.
- **URLSession**: Para realizar solicitudes de red.
- **XCTest**: Para pruebas unitarias.
- **UserDefaults**: Para almacenar de forma segura las credenciales de inicio de sesión.
- **Diffable Data Source**: Para actualizaciones eficientes en `UICollectionView`.

## Estrategia de Pruebas

Para garantizar la confiabilidad de la capa de red y la gestión del estado de la aplicación, se utiliza el siguiente enfoque de pruebas:

- **Simulación de la Capa de Red**: Se utiliza `APIClientProtocolMock` para simular respuestas de red en las pruebas.
- **Pruebas Unitarias**: Las pruebas verifican el flujo de inicio de sesión, la validación del token y la obtención de datos de personajes, asegurando que la aplicación maneje correctamente los casos de éxito y error.
- **Casos de Borde**: Las pruebas incluyen el manejo de tokens faltantes, URLs malformadas y fallos de red.

## Contribuyendo

1. Haz un fork del repositorio.
2. Crea una rama de características: `git checkout -b feature-branch`.
3. Realiza tus cambios: `git commit -m 'Añadir nueva característica'`.
4. Sube la rama: `git push origin feature-branch`.
5. Envía un pull request.

## Licencia

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo [LICENSE](LICENSE) para más detalles.
