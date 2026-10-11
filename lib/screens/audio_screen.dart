import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class PistaAudio {
  final String titulo;
  final String descripcion;
  final String ruta;

  const PistaAudio({
    required this.titulo,
    required this.descripcion,
    required this.ruta,
  });
}

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late final AudioPlayer _player;

  int? _indiceSeleccionado;
  bool _cargando = false;
  bool _reproduciendo = false;

  final List<PistaAudio> _pistas = const [
    PistaAudio(
      titulo: 'Cambio de aceite',
      descripcion: 'Cada cuánto cambiarlo y cuándo adelantarlo.',
      ruta: 'assets/audio/consejo_aceite.wav',
    ),
    PistaAudio(
      titulo: 'Cuidado de los frenos',
      descripcion: 'Reconoce señales de desgaste en los frenos.',
      ruta: 'assets/audio/consejo_frenos.wav',
    ),
    PistaAudio(
      titulo: 'Cuidado de las gomas',
      descripcion: 'Presión correcta y desgaste de las gomas.',
      ruta: 'assets/audio/consejo_gomas.wav',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();

    _player.playerStateStream.listen((estado) {
      if (!mounted) return;

      setState(() {
        _reproduciendo = estado.playing &&
            estado.processingState != ProcessingState.completed;
      });
    });

    _player.playbackEventStream.listen(
      (_) {},
      onError: (Object error, StackTrace stackTrace) {
        debugPrint('ERROR DEL REPRODUCTOR: $error');
        debugPrint('$stackTrace');
      },
    );
  }

  Future<void> _seleccionarPista(int indice) async {
    if (_cargando) return;

    setState(() {
      _indiceSeleccionado = indice;
      _cargando = true;
      _reproduciendo = false;
    });

    try {
      debugPrint('Cargando audio: ${_pistas[indice].ruta}');

      await _player.stop();
      await _player.setAsset(_pistas[indice].ruta);

      final duracion = _player.duration;
      debugPrint('Audio cargado. Duración: $duracion');

      if (duracion == null || duracion == Duration.zero) {
        throw Exception(
          'El archivo de audio no tiene una duración válida.',
        );
      }

      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      await _player.play();
    } catch (error, stackTrace) {
      debugPrint('ERROR AL REPRODUCIR: $error');
      debugPrint('$stackTrace');

      if (!mounted) return;

      setState(() {
        _cargando = false;
        _reproduciendo = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo reproducir el audio: $error'),
          duration: const Duration(seconds: 6),
        ),
      );
    }
  }

  Future<void> _alternarReproduccion() async {
    if (_cargando) return;

    if (_indiceSeleccionado == null) {
      await _seleccionarPista(0);
      return;
    }

    try {
      final estado = _player.playerState;

      if (estado.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
        await _player.play();
      } else if (_player.playing) {
        await _player.pause();
      } else {
        await _player.play();
      }
    } catch (error, stackTrace) {
      debugPrint('ERROR EN LOS CONTROLES: $error');
      debugPrint('$stackTrace');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al reproducir: $error'),
        ),
      );
    }
  }

  Future<void> _detener() async {
    try {
      await _player.stop();

      if (!mounted) return;

      setState(() {
        _reproduciendo = false;
      });
    } catch (error) {
      debugPrint('Error al detener el audio: $error');
    }
  }

  Future<void> _reiniciar() async {
    if (_indiceSeleccionado == null || _cargando) return;

    try {
      await _player.seek(Duration.zero);
      await _player.play();
    } catch (error) {
      debugPrint('Error al reiniciar el audio: $error');
    }
  }

  String _formatearTiempo(Duration tiempo) {
    final minutos = tiempo.inMinutes;
    final segundos = tiempo.inSeconds % 60;

    return '$minutos:${segundos.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pistaActual = _indiceSeleccionado == null
        ? null
        : _pistas[_indiceSeleccionado!];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio de mantenimiento'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Aprende a cuidar tu vehículo',
                    style: appHeading(size: 20),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Escucha consejos prácticos de mantenimiento.',
                    style: appBody(
                      size: 12.5,
                      color: AppColors.charcoal.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              itemCount: _pistas.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, indice) {
                final pista = _pistas[indice];
                final seleccionada = indice == _indiceSeleccionado;

                return ListTile(
                  tileColor: seleccionada
                      ? AppColors.orange.withOpacity(0.08)
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(
                      color: seleccionada
                          ? AppColors.orange
                          : AppColors.charcoal.withOpacity(0.12),
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  leading: CircleAvatar(
                    backgroundColor: seleccionada
                        ? AppColors.orange
                        : AppColors.charcoal.withOpacity(0.08),
                    child: Icon(
                      seleccionada
                          ? Icons.graphic_eq
                          : Icons.headphones,
                      color: seleccionada
                          ? AppColors.paper
                          : AppColors.charcoal,
                    ),
                  ),
                  title: Text(
                    pista.titulo,
                    style: appBody(
                      size: 13.5,
                      weight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      pista.descripcion,
                      style: appBody(
                        size: 11.5,
                        color: AppColors.charcoal.withOpacity(0.55),
                      ),
                    ),
                  ),
                  trailing: seleccionada && _cargando
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : Icon(
                          seleccionada && _reproduciendo
                              ? Icons.equalizer
                              : Icons.play_circle_outline,
                          size: 30,
                          color: seleccionada
                              ? AppColors.orange
                              : AppColors.charcoal.withOpacity(0.6),
                        ),
                  onTap: () => _seleccionarPista(indice),
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.steel,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  pistaActual?.titulo ?? 'Selecciona un audio',
                  textAlign: TextAlign.center,
                  style: appHeading(
                    size: 16,
                    color: AppColors.paper,
                  ),
                ),
                const SizedBox(height: 12),
                StreamBuilder<Duration?>(
                  stream: _player.durationStream,
                  builder: (context, duracionSnapshot) {
                    final duracion =
                        duracionSnapshot.data ?? Duration.zero;

                    return StreamBuilder<Duration>(
                      stream: _player.positionStream,
                      builder: (context, posicionSnapshot) {
                        final posicion =
                            posicionSnapshot.data ?? Duration.zero;

                        final posicionSegura =
                            posicion > duracion ? duracion : posicion;

                        final maximo =
                            duracion.inMilliseconds.toDouble();

                        final valor = posicionSegura.inMilliseconds
                            .toDouble()
                            .clamp(
                              0.0,
                              maximo > 0 ? maximo : 1.0,
                            );

                        return Column(
                          children: [
                            Slider(
                              min: 0,
                              max: maximo > 0 ? maximo : 1.0,
                              value: valor,
                              activeColor: AppColors.orange,
                              inactiveColor:
                                  AppColors.paper.withOpacity(0.25),
                              onChanged: duracion == Duration.zero
                                  ? null
                                  : (nuevoValor) {
                                      _player.seek(
                                        Duration(
                                          milliseconds:
                                              nuevoValor.round(),
                                        ),
                                      );
                                    },
                            ),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatearTiempo(posicionSegura),
                                  style: appBody(
                                    size: 11.5,
                                    color: AppColors.paper
                                        .withOpacity(0.8),
                                  ),
                                ),
                                Text(
                                  _formatearTiempo(duracion),
                                  style: appBody(
                                    size: 11.5,
                                    color: AppColors.paper
                                        .withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Reiniciar',
                      onPressed: pistaActual == null || _cargando
                          ? null
                          : _reiniciar,
                      icon: const Icon(Icons.replay),
                      iconSize: 30,
                      color: AppColors.paper,
                      disabledColor:
                          AppColors.paper.withOpacity(0.3),
                    ),
                    const SizedBox(width: 18),
                    SizedBox(
                      width: 64,
                      height: 64,
                      child: _cargando
                          ? const CircularProgressIndicator(
                              color: AppColors.caution,
                            )
                          : IconButton.filled(
                              tooltip: _reproduciendo
                                  ? 'Pausar'
                                  : 'Reproducir',
                              onPressed: _alternarReproduccion,
                              iconSize: 36,
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.orange,
                                foregroundColor: AppColors.paper,
                              ),
                              icon: Icon(
                                _reproduciendo
                                    ? Icons.pause
                                    : Icons.play_arrow,
                              ),
                            ),
                    ),
                    const SizedBox(width: 18),
                    IconButton(
                      tooltip: 'Detener',
                      onPressed: pistaActual == null || _cargando
                          ? null
                          : _detener,
                      icon: const Icon(Icons.stop),
                      iconSize: 30,
                      color: AppColors.paper,
                      disabledColor:
                          AppColors.paper.withOpacity(0.3),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}