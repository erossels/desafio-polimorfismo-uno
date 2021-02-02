# README

## PARTE I.  

- [x] Las migraciones y modelos para manejar los tipos de productos.

*Creamos el modelo para las fotografías que tendrán los productos. Usaremos polimorfismo para poder usar este modelo en los productos sean físicos o digitales.*

```ruby
rails g model photo url photoable:references{polymorphic}
```

*Creamos un modelo para los productos (**product**) y dos modelos adicionales (**physical** y **digital**) que heredarán de producto.*

```ruby
rails g model product name price:float
rails g model physical
rails g model digital
```

*Modificaremos los modelos **physical** y **digital** de modo que hereden de **product** y además tengan fotografías asociadas: una en el caso del producto digital y varias en el físico.*

```ruby
class Physical < Product
  has_many :photos, as: :photoable 
end

class Digital < Product
  has_one :photo, as: :photoable 
end
```

- [x] Las migraciones y modelos para manejar los medios de pago.

*Para manejar los medios de pago crearemos los modelos: **PaymentMethod** y **Payment**. El modelo PaymentMethod tendrá un nombre. Tendremos un método **Option** para clasificar los tipos de pago en transbank. El modelo Payment referenciará a la orden de compra, método de pago, tendrá un status y un total asociado.*

```ruby
rails g model PaymentMethod name code
rails g model Payment order:references payment_method:references
rails g model Option optionable:references{polymorphic} name
```

*Modificamos el modelo PaymentMethod de modo que tenga opciones.*
```ruby
class PaymentMethod < ApplicationRecord
  has_many :options, as: :optionable
end
```


- [x] Un formulario para simular los medios de pago. Implementarás un modelo Orden de Compra (básico) para poder asociarlo al pago.

*Crearemos un modelo ordenes de compra para asociar al pago. Esto contempla el modelo de la orden de compra (**order**) que tiene un total*

```ruby
rails g model order total:float
```

*Se implementa un formulario de pago, donde a modo de prueba se ingresa el número de orden y el método de pago*

```ruby
<h1>Formulario de pago [BORRADOR]</h1>
    <% if notice %>
      <p><%= notice %></p>
    <% end %>
  <%= form_with(model: @payment, local: true) do |form| %>

    <div class="field"> 
      <%= form.label :order_id %>
      <%= form.number_field :order_id %>
    </div>

    <div class="field"> 
      <%= form.label "Select Payment Method" %>
      <%= form.collection_select(:payment_method_id, @payment_methods, :id, :name)  %>
    </div>

    <%= form.submit "Pay" %>
  <% end %>

```

*Si el usuario escoge el método transbank, será redigirido a un segundo formulario. Básicamente está editando la instancia de pago. En este caso si se incluye las opciones de pago de transbank*

```ruby
<h1>Formulario de pago [BORRADOR]</h1>
    <% if notice %>
      <p><%= notice %></p>
    <% end %>
  <%= form_with(model: @payment, local: true) do |form| %>

    <div class="field"> 
      <%= form.label :order_id %>
      <%= form.number_field :order_id %>
    </div>

    <div class="field"> 
      <%= form.label "Select Payment Method" %>
      <%= form.collection_select(:payment_method_id, @payment_methods, :id, :name)  %>
    </div>

    <div>
      <h4>Escoge la opción transbank</h4>
      <div class="field"> 
        <%= form.label "Select Payment Method" %>
        <%= form.collection_select(:option_id, @payment_methods.find(3).options, :id, :name)  %>
      </div>
    </div>

    <%= form.submit "Pay" %>
  <% end %>

```

*Lo anterior es posible gracias a lo que hemos definido en el controller de **payments**. En particular el método **create***

```ruby
  def create
    @payment = Payment.new(payment_params)
    @payment.status = 'created'
    @payment.total = 10_000
    @payment.payment_method_id = params[:payment][:payment_method_id]
    @payment.save
    @payment.option = nil

    if @payment.payment_method_id == 3 && @payment.option.nil?
      redirect_to edit_payment_path(@payment.id) and return
    end

    respond_to do |format|
      if @payment.save
        format.html { redirect_to root_path, notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @payment }
      else
        format.html { redirect_to root_path, notice: 'Payment failed' }
        format.json { render json: @payment.errors, status: :unprocessable_entity }
      end
    end
  end
```


## PARTE II  

- [x] Tú, como alumno más avanzado, le ayudarás a estudiar y elaborarás un mini proyecto en Rails explicando paso a paso cómo mejorar la implementación anterior, desde la creación del proyecto hasta la inserción de datos desde consola. Tendrás que crear un diagrama con los modelos involucrados y ejemplos para que tu compañero de clase los pueda usar desde la consola de Rails.

```ruby
class​ ​Animal​ < ApplicationController ​# ...
  ​def​ ​create
    # ...
    kind = params[​:animal​][​:kind​]
    if​ kind == ​"Dog"​:
    animal = Dog.new(animal_params)
    elsif​ kind == ​"Cat"
    animal = Cat.new(animal_params)
    else
    animal = Cow.new(animal_params)
    end ​
  end
end
```

*Para mejorar el proyecto vamos a implementar polimorfismo, esto es posible a través de herencia, duck-typing o decorador. En este caso seguiremos el patrón de diseño duck-typing. Esto considera la creación de un objeto, que tendrá la capacidad de recibir como parámetro otro objeto. En este caso crearemos un objeto **animal** que tendrá algunos métodos que esperaríamos tuvieran los animales, por ahora comer y moverse*

*Crearemos los modelos animal, cat, dog y cow, para luego correr las migraciones.*

```ruby
rails g model animal name
rails g model dog
rails g model cat
rails g model cow
rails db:migrate
```

*Vamos a implementar los modelos **eats** y **moves** en la clase animal, en ambos casos el método recibirá un objeto animal, estos serán nuestros modelos dog, cat y cow*

```ruby
class Animal < ApplicationRecord
  def eats(animal)
    animal.eats
  end

  def moves(animal)
    animal.moves
  end
end
```

*Luego si queremos generar nuevas especies, las podemos crear de la siguiente manera. Creemos un Perro, un gato y una vaca. En cada caso modificaremos la conducta (métodos) **moves** y **eats***

```ruby
class Dog < ApplicationRecord
  def moves
    puts 'Me iré corriendo de aquí'
  end
  
  def eats
    puts 'Me encanta comer huesos'
  end
end

class Cow < ApplicationRecord
  def moves
    puts 'Iré a pasear por el pasto'
  end
  
  def eats
    puts 'Este pasto se ve sabroso, me lo comeré'
  end
end

class Cat < ApplicationRecord
  def moves
    puts 'Me iré caminando de aquí'
  end
  
  def eats
    puts 'Humano trae mi comida'
  end
end

```

*Pongamos a prueba nuestros animales. Entraremos a la consola para probar los modelos*

```
rails c
animal = Animal.create
dog = Dog.create
cat = Cat.create
cow = Cow.create
```

*Si probamos los métodos eats y moves sobre el modelo animal pasa lo siguiente*

```
2.6.6 :009 > animal.eats
Traceback (most recent call last):
        2: from (irb):9
        1: from app/models/animal.rb:2:in `eats'
ArgumentError (wrong number of arguments (given 0, expected 1))
```

*Pero si probamos los métodos entregando a animal un tipo específico, tendremos distintos comportamientos.*

```
.6.6 :010 > animal.eats(dog)
Le diré a mi dueño que me de comida
 => nil 
2.6.6 :011 > animal.eats(cat)
Humano trae mi comida
 => nil 
2.6.6 :012 > animal.eats(cow)
Este pasto se ve sabroso, me lo comeré
 => nil 
2.6.6 :014 > animal.moves(dog)
Me iré corriendo de aquí
 => nil 
2.6.6 :015 > animal.moves(cat)
Me iré caminando de aquí
 => nil 
2.6.6 :016 > animal.moves(cow)
Iré a pasear por el pasto
 => nil 
2.6.6 :017 > 
```
