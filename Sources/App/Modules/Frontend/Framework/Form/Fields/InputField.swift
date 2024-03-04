public final class InputField: AbstractFormField<
    String,
    InputFieldTemplate
> {

    public convenience init(
        _ key: String,
        title: String? = nil
    ) {
        self.init(
            key: key,
            input: "",
            output: .init(
                .init(
                    key: key,
                    label: .init(key: key, title: title)
                )
            )
        )
    }
}
