using Microsoft.AspNetCore.Mvc;
using ProductApi.Models;

namespace ProductApi.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class ProductController : ControllerBase
    {
        private static List<Product> products = new()
        {
            new Product
            {
                Id = 1,
                Name = "Auriculares Bluetooth",
                Description = "Auriculares inalámbricos con cancelación de ruido y batería de 20 horas.",
                Price = 120000,
                Category = "Electronica"
            },
            new Product
            {
                Id = 2,
                Name = "Mochila Antirrobo",
                Description = "Mochila con compartimientos ocultos y puerto USB para carga.",
                Price = 90000,
                Category = "Accesorios"
            },
            new Product
            {
                Id = 3,
                Name = "Cafetera Italiana",
                Description = "Cafetera clásica de aluminio para preparar café espresso en casa.",
                Price = 67000,
                Category = "Hogar"
            }
        };

        [HttpGet]
        [Route("GetProducts")]
        public IEnumerable<Product> GetUsers()
        {
            return products;
        }

        [HttpGet]
        [Route("GetProductsByParameter")]
        public IEnumerable<Product> GetUsersByParameter([FromHeader] string parameter)
        {
            if (string.IsNullOrWhiteSpace(parameter))
                return Enumerable.Empty<Product>();

            decimal ageFilter;
            bool isNumber = decimal.TryParse(parameter, out ageFilter);

            return products.Where(x =>
                x.Name.Contains(parameter, StringComparison.OrdinalIgnoreCase) ||
                (isNumber && x.Price == ageFilter) ||
                x.Category.Contains(parameter, StringComparison.OrdinalIgnoreCase)
            );
        }

        [HttpPost]
        [Route("CreateProduct")]
        public ActionResult<Product> CreateProduct([FromBody] RequestProduct product)
        {
            Product newProduct = new Product
            {
                Id = products.Last().Id + 1,
                Name = product.Name,
                Description = product.Description,
                Price = product.Price,
                Category = product.Category
            };

            products.Add(newProduct);

            return newProduct;
        }

        [HttpPost]
        [Route("UpdateProduct")]
        public ActionResult<Product> UpdateProduct([FromBody] Product product)
        {
            var productExist = products.FirstOrDefault(x => x.Id == product.Id);
            if (productExist == null)
            {
                throw new Exception($"El producto {product.Name} no se encuentra registrado en el sistema.");
            }
            else
            {
                productExist.Name = string.IsNullOrEmpty(product.Name) ? productExist.Name : product.Name;
                productExist.Description = string.IsNullOrEmpty(product.Description) ? productExist.Description : product.Description;
                productExist.Price = product.Price == 0 ? productExist.Price : product.Price;
                productExist.Category = string.IsNullOrEmpty(product.Category) ? productExist.Category : product.Category;

                return productExist;
            }
        }

        [HttpPost]
        [Route("DeleteProduct")]
        public ActionResult<Product> DeleteProduct([FromHeader] int id)
        {
            var productExist = products.FirstOrDefault(x => x.Id == id);
            if (productExist == null)
            {
                throw new Exception($"El producto no se encuentra registrado en el sistema.");
            }
            else
            {

                products.Remove(productExist);
                return Ok(new { message = $"El producto con Id {id} fue eliminado correctamente." });
            }
        }
    }
}
