# coding: utf-8


import ConfigParser
import json
import os
import shutil
import sys
import argparse
import re


class CMakeGenerator(object):

    def __init__(self):
        self.read_config()
        self.build_dir = 'build-({0})-{1}'.format(self.project_type,
                                                  self.build_type)
        self.print_config()
        self.execute()

    def read_config(self):
        config = ConfigParser.ConfigParser()
        config.read('cmake.ini')
        generators = json.loads(config.get('cmake', 'generators'))
        default_generator = json.loads(
            config.get('cmake', 'default_generator'))
        self.project_type = generators[default_generator]
        self.build_type = json.loads(config.get('cmake', 'build_type'))
        self.delete_cache = json.loads(config.get('cmake', 'delete_cache'))
        self.options = json.loads(config.get('cmake', 'options'))

    def print_config(self):
        print('Project type: ' + self.project_type)
        print('Build type: ' + self.build_type)
        print('Delete cache: {}'.format(self.delete_cache))
        print('Build directory: ' + self.build_dir)
        print('Options: {}'.format(self.options))

    def execute(self):
        if os.path.isdir(self.build_dir) is False:
            print('creating build director[{}]...'.format(self.build_dir))
            os.mkdir(self.build_dir)
        if self.delete_cache:
            print('deleting cache...')
            shutil.rmtree(self.build_dir)
            os.mkdir(self.build_dir)

        os.chdir(self.build_dir)
        cmd = 'cmake -G"{0}" -DCMAKE_BUILD_TYPE={1} .. '.format(
            self.project_type, self.build_type)
        for option in self.options:
            cmd += ' ' + option
        print(cmd)
        os.system(cmd)


def clean():
    for d in [f for f in os.listdir('.') if re.match(r'build-\(.*\)-.*', f)]:
        print('cleanning {} ...'.format(d))
        shutil.rmtree(d)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--clean', action='store_true', help='clean cmake build cache')
    args = parser.parse_args()
    if args.clean:
        clean()
    else:
        cmake = CMakeGenerator()
