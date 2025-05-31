import pygame
import pytmx
import pyscroll
import pytmx.util_pygame
from settings import *

from entity import Player
from items import Sword

class Game:
    def __init__(self):
        self.screen = pygame.display.set_mode((WIDTH, HEIGHT))
        self.is_playing = True

        # chargement de la carte
        tmx_data = pytmx.util_pygame.load_pygame(file_tmx)
        map_data= pyscroll.data.TiledMapData(tmx_data)
        map_layer = pyscroll.orthographic.BufferedRenderer(map_data, self.screen.get_size())
        map_layer.zoom = 2

        # générer le joueur
        player_position = tmx_data.get_object_by_name('player')
        self.player = Player(player_position.x, player_position.y)

        # générer une arme
        sword_position = tmx_data.get_object_by_name('sword')
        self.sword = Sword(sword_position.x, sword_position.y)

        # zones de collision
        self.walls = []

        for object in tmx_data.objects:
            if object.name == "collision":
                self.walls.append(pygame.Rect(object.x, object.y, object.width, object.height))
                 
        # groupe des calques de tuiles
        self.group = pyscroll.PyscrollGroup(map_layer=map_layer, default_layer = 4)
        self.group.add(self.player)
        self.group.add(self.sword)

    def handle_input(self):
        pressed = pygame.key.get_pressed()

        if pressed[pygame.K_UP]:
            self.player.move('up')
            self.player.change_animation('up')
        elif pressed[pygame.K_DOWN]:
            self.player.move('down')
            self.player.change_animation('down')
        elif pressed[pygame.K_LEFT]:
            self.player.move('left')
            self.player.change_animation('left')
        elif pressed[pygame.K_RIGHT]:
            self.player.move('right')
            self.player.change_animation('right')

    def update(self):
        self.group.update()

        # vérifie si il y a une collision
        for sprite in self.group.sprites():
            if isinstance(sprite, Player):
                if sprite.feet.collidelist(self.walls) > -1 :
                    sprite.move_back()
        
        self.sword.change_animation('sword')

    
    def draw(self):

        if not self.is_playing:
            pass
        else:
            self.group.center(self.player.rect)
            self.group.draw(self.screen)

        # Maj du l'affichage
        pygame.display.flip()
            


    def run(self):
        clock = pygame.time.Clock()

        running = True
        while running:
            
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False
            
            # mémorise la position du jouer
            self.player.save_location()

            # récupère les touches pressées 
            self.handle_input()

            # Rendu du contenu du jeu
            self.update()

            self.draw()

            clock.tick(FPS)  # Bride les FPS à 60

        pygame.quit()