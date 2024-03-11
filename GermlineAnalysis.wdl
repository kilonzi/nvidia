task GermlineAnalysis {
    input {
        File ref
        Array[File] in_fq
        File knownSites
        String output_prefix
    }

    command {
        pbrun germline \
            --ref ~{ref} \
            --in-fq ~{sep=" " in_fq} \
            --knownSites ~{knownSites} \
            --out-bam ~{output_prefix}.bam \
            --out-variants ~{output_prefix}_germline.vcf \
            --out-recal-file ~{output_prefix}_recal.txt
    }

    output {
        File bam_output = "~{output_prefix}.bam"
        File vcf_output = "~{output_prefix}_germline.vcf"
        File recal_file = "~{output_prefix}_recal.txt"
    }

    runtime {
        docker: "johnkilonzi/nvidia-clara-parabricks:latest"
    }
}

workflow GermlineWorkflow {
    input {
        File ref
        Array[File] in_fq
        File knownSites
        String output_prefix
    }

    call GermlineAnalysis {
        input:
            ref = ref,
            in_fq = in_fq,
            knownSites = knownSites,
            output_prefix = output_prefix
    }

    output {
        File bam_output = GermlineAnalysis.bam_output
        File vcf_output = GermlineAnalysis.vcf_output
        File recal_file = GermlineAnalysis.recal_file
    }
}
