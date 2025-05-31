import pygame

class Item(pygame.sprite.Sprite):
    def __init__(self, name, x, y):
        super().__init__()

        self.sprite_sheet = pygame.image.load(f'assets/{name}.png')
        self.image = self.get_image(0,0)
        self.image.set_colorkey([0,0,0]) # gérer la transparence
        self.rect = self.image.get_rect()
        self.animation_index = 0
        self.animation_images = {
            'sword' : self.get_images()
        }
        self.position = [x,y]
        self.speed = 2
        self.clock = 0

    def change_animation(self, name): 
        self.image = self.animation_images[name][self.animation_index]
        self.image.set_colorkey([0,0,0])
        self.clock += self.speed * 2

        if self.clock >= 100:
            self.animation_index += 1
            if self.animation_index >= len(self.animation_images[name]):
                self.animation_index = 0
            
            self.clock = 0

    def get_images(self):

        images = []

        for i in range(0,3):
            x = i * 32
            image = self.get_image(x, 0)
            images.append(image)
        
        return images
    
    def get_image(self, x, y):
        image = pygame.Surface([32,32])
        image.blit(self.sprite_sheet, (0,0), (x,y,32,32))
        return image 


class Sword(Item):
    def __init__(self, x, y):
        super().__init__('sword', x, y)
