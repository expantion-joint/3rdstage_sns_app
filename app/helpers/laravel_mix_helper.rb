module LaravelMixHelper
  class LaravelMixError < StandardError; end
  MANIFEST_FILE = 'public/mix-manifest.json'

  def mix(path)
    unless File.exist?(MANIFEST_FILE)
      raise LaravelMixError, "The Mix manifest does not exist at #{MANIFEST_FILE}. Run `yarn run dev`."
    end

    manifest = JSON.parse(File.read(MANIFEST_FILE))
    asset_path(manifest.fetch(path) { raise LaravelMixError, "No asset found for #{path} in the Mix manifest." })
  end
  
  #mix関数はコンパイルしたCSSやJavascriptを読み込むURLを生成する役割がある
  #コンパイル後のファイルを読み込むためのURLを生成している
  
end
