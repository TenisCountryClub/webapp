class Munkres
 minimizar_costo = 1
  minimizar_costo_util = 2
  
  def inicializar(matriz=[], modo=Modo_minimizar_costo)
    @matriz = matriz
    @modo = modo
    @original = Marshal.load(Marshal.dump(@matriz))
    @columnas_cubiertas = []
    @filas_cubiertas = []
    @ceros_uno = []
    @ceros_dos = []
    
    class << @matriz
      

      def filas(index)
        self[index]
      end

      def columnas(index)
        self.recolectar do |filas|
          filas[index]
        end
      end

      def columnas
        resultado = []
        self.first.each_index do |i|
          resultado << self.columnas(i)
        end
        resultado
      end
      
      def cada_columna &block
        columna_indices.each &block
      end
      
      def columna_indices
        @columna_indices ||= (0...self.first.size).to_a
      end
      
      def filas_indices
        @filas_indices ||= (0...self.size).to_a
      end
    end
    
  end
  
  def encontrar_pares
    crear_cero_en_filas
    ceros
  
    while not done?
      p = cubrir_ceros_crear_mas
      encontrar_mejor_ceros p
      cubrir_columnas_con_ceros
    end
    @pares = @ceros_uno.delete_if{|filas_index,col_index| col_index >= @original.first.size || filas_index >= @original.size}
  end
  
  def costo_total_pares
    @pares.inject(0) {|total, cero| total + @original[cero[0]][cero[1]]}
  end
  
 

  def crear_cero_en_filas
    @matriz.each_with_index do |filas,filas_index|
      min_val = min_o_cero(filas)
      filas.each_with_index do |valor, col_index|
        @matriz[filas_index][col_index] = valor - min_val
      end
    end
  end
  
  def columnas_ceros
    columnas = @matriz.columna_indice
    
    @matriz.each_with_index do |filas, filas_index|
      cero = cero?(filas_index)
      next if cero
      unstarred_columnas.each do |col_index|
          if (filas[col_index] == 0 and !star_in_column?(col_index))
          @ceros_uno << [filas_index, col_index]
          unstarred_columnas -= [col_index]
          break
        end
      end
    end
  end
  
  def cubrir_columnas
    cols = @ceros_uno.recolectar {|z| z[1]}
    cols.uniq!
    @columnas_cubiertas += cols
  end
  
  def cubrir_filas
    my_cols = columnas_cubiertas 
    
    unfilas_cubiertas.each do |filas_index|
      mi_cols.each do |col_index|
        if @matriz[filas_index][col_index] == 0
          @ceros_dos << [filas_index, col_index]
          return [filas_index, col_index]
        end
      end
    end
    nil
  end
end