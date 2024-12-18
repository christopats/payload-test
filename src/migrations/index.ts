import * as migration_20241218_095425_init from './20241218_095425_init';

export const migrations = [
  {
    up: migration_20241218_095425_init.up,
    down: migration_20241218_095425_init.down,
    name: '20241218_095425_init'
  },
];
